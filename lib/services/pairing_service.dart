/// DM pairing system matching OpenClaw.
///
/// Unknown senders get an 8-char code. Messages are held until the owner approves.
/// Codes expire after 1 hour. Max 3 pending per channel.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutterclaw/data/models/config.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.pairing');

const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no 0,O,1,I
const _codeLength = 8;
const _maxPendingPerChannel = 3;
const _expirationMinutes = 60;

class PairingRequest {
  final String channel;
  final String senderId;
  final String senderName;
  final String code;
  final DateTime createdAt;

  PairingRequest({
    required this.channel,
    required this.senderId,
    required this.senderName,
    required this.code,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(createdAt).inMinutes > _expirationMinutes;

  Map<String, dynamic> toJson() => {
        'channel': channel,
        'senderId': senderId,
        'senderName': senderName,
        'code': code,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PairingRequest.fromJson(Map<String, dynamic> json) => PairingRequest(
        channel: json['channel'] as String,
        senderId: json['senderId'] as String,
        senderName: json['senderName'] as String? ?? '',
        code: json['code'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

/// An approved device entry with ID and display name.
class ApprovedDevice {
  final String id;
  final String name;
  ApprovedDevice({required this.id, required this.name});
}

class PairingService {
  final ConfigManager configManager;
  final Map<String, List<PairingRequest>> _pending = {};
  /// channel → { senderId → senderName }
  final Map<String, Map<String, String>> _approved = {};
  String? _credentialsDir;

  PairingService({required this.configManager});

  Future<String> _getCredentialsDir() async {
    if (_credentialsDir != null) return _credentialsDir!;
    final configDir = await configManager.configDir;
    _credentialsDir = '$configDir/credentials';
    await Directory(_credentialsDir!).create(recursive: true);
    return _credentialsDir!;
  }

  String _generateCode() {
    final rng = Random.secure();
    return List.generate(_codeLength, (_) => _chars[rng.nextInt(_chars.length)])
        .join();
  }

  /// Check if a sender is approved for a channel.
  Future<bool> isApproved(String channel, String senderId) async {
    await _loadApproved(channel);
    return _approved[channel]?.containsKey(senderId) ?? false;
  }

  /// Create a pairing request. Returns the code, or null if at capacity.
  Future<String?> createRequest(
    String channel,
    String senderId,
    String senderName,
  ) async {
    await _loadPending(channel);
    final list = _pending[channel] ?? [];

    // Remove expired
    list.removeWhere((r) => r.isExpired);

    // Check if already pending
    final existing = list.where((r) => r.senderId == senderId).firstOrNull;
    if (existing != null && !existing.isExpired) return existing.code;

    // Check capacity
    if (list.length >= _maxPendingPerChannel) return null;

    final code = _generateCode();
    final request = PairingRequest(
      channel: channel,
      senderId: senderId,
      senderName: senderName,
      code: code,
    );

    list.add(request);
    _pending[channel] = list;
    await _savePending(channel);

    _log.info('Pairing request created: $channel/$senderId -> $code');
    return code;
  }

  /// Approve a pairing request by code.
  Future<bool> approve(String channel, String code) async {
    await _loadPending(channel);
    final list = _pending[channel] ?? [];
    final request = list.where((r) => r.code == code && !r.isExpired).firstOrNull;

    if (request == null) return false;

    // Add to approved
    await _loadApproved(channel);
    _approved.putIfAbsent(channel, () => {});
    _approved[channel]![request.senderId] = request.senderName;
    await _saveApproved(channel);

    // Remove from pending
    list.removeWhere((r) => r.code == code);
    _pending[channel] = list;
    await _savePending(channel);

    _log.info('Approved pairing: $channel/${request.senderId}');
    return true;
  }

  /// Reject a pairing request by code.
  Future<void> reject(String channel, String code) async {
    await _loadPending(channel);
    final list = _pending[channel] ?? [];
    list.removeWhere((r) => r.code == code);
    _pending[channel] = list;
    await _savePending(channel);
  }

  /// Get all pending (non-expired) requests for a channel.
  Future<List<PairingRequest>> getPending(String channel) async {
    await _loadPending(channel);
    final list = _pending[channel] ?? [];
    list.removeWhere((r) => r.isExpired);
    return List.from(list);
  }

  /// Get all pending requests across all channels.
  Future<List<PairingRequest>> getAllPending() async {
    final dir = await _getCredentialsDir();
    final d = Directory(dir);
    if (!await d.exists()) return [];

    final all = <PairingRequest>[];
    await for (final entity in d.list()) {
      if (entity is File && entity.path.endsWith('-pairing.json')) {
        final channel = entity.path
            .split('/')
            .last
            .replaceAll('-pairing.json', '');
        all.addAll(await getPending(channel));
      }
    }
    return all;
  }

  // -- Persistence --

  Future<void> _loadPending(String channel) async {
    if (_pending.containsKey(channel)) return;
    final dir = await _getCredentialsDir();
    final file = File('$dir/$channel-pairing.json');
    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        final list = (jsonDecode(content) as List<dynamic>)
            .map((e) => PairingRequest.fromJson(e as Map<String, dynamic>))
            .toList();
        _pending[channel] = list;
      } catch (e) {
        _log.warning('Failed to load pairing for $channel: $e');
        _pending[channel] = [];
      }
    } else {
      _pending[channel] = [];
    }
  }

  Future<void> _savePending(String channel) async {
    final dir = await _getCredentialsDir();
    final file = File('$dir/$channel-pairing.json');
    final list = _pending[channel] ?? [];
    await file.writeAsString(jsonEncode(list.map((r) => r.toJson()).toList()));
  }

  Future<void> _loadApproved(String channel) async {
    if (_approved.containsKey(channel)) return;
    final dir = await _getCredentialsDir();
    final file = File('$dir/$channel-allowFrom.json');
    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        final raw = jsonDecode(content) as List<dynamic>;
        final map = <String, String>{};
        for (final entry in raw) {
          if (entry is String) {
            // backward compat: plain ID list, no name
            map[entry] = '';
          } else if (entry is Map<String, dynamic>) {
            map[entry['id'] as String] = entry['name'] as String? ?? '';
          }
        }
        _approved[channel] = map;
      } catch (e) {
        _log.warning('Failed to load allowFrom for $channel: $e');
        _approved[channel] = {};
      }
    } else {
      _approved[channel] = {};
    }
  }

  Future<void> _saveApproved(String channel) async {
    final dir = await _getCredentialsDir();
    final file = File('$dir/$channel-allowFrom.json');
    final map = _approved[channel] ?? {};
    final list = map.entries
        .map((e) => {'id': e.key, 'name': e.value})
        .toList();
    await file.writeAsString(jsonEncode(list));
  }

  /// Get all approved devices for a channel (id → name).
  Future<Map<String, String>> getApproved(String channel) async {
    await _loadApproved(channel);
    return Map.from(_approved[channel] ?? {});
  }

  /// Manually add an approved device (e.g. from the settings UI).
  Future<void> addApproved(String channel, String id, String name) async {
    await _loadApproved(channel);
    _approved.putIfAbsent(channel, () => {});
    _approved[channel]![id] = name;
    await _saveApproved(channel);
  }

  /// Remove an approved device.
  Future<void> removeApproved(String channel, String id) async {
    await _loadApproved(channel);
    _approved[channel]?.remove(id);
    await _saveApproved(channel);
  }
}
