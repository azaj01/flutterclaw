/// Camera tools for FlutterClaw agents.
///
/// Take photos and record video using the device camera (via image_picker).
/// Photos are returned as base64 so agents can process them with vision models.
library;

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'registry.dart';

/// Takes a photo using the device camera and returns it as base64 + metadata.
///
/// The returned JSON is compatible with the vision content block format used
/// by AnthropicProvider and OpenAiProvider, so the agent can pass it directly
/// to a vision-capable model.
class CameraTakePhotoTool extends Tool {
  @override
  String get name => 'camera_take_photo';

  @override
  String get description =>
      'Open the device camera to take a photo. '
      'Returns the image as a base64-encoded JPEG with its MIME type. '
      'The agent can then describe, analyze, or send the image to a vision model.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'save_to_gallery': {
            'type': 'boolean',
            'description':
                'Whether to save the photo to the device gallery (default: false).',
          },
          'max_width': {
            'type': 'integer',
            'description': 'Max image width in pixels (default: 1920).',
          },
          'max_height': {
            'type': 'integer',
            'description': 'Max image height in pixels (default: 1920).',
          },
        },
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final maxWidth = (args['max_width'] as num?)?.toDouble() ?? 1920.0;
    final maxHeight = (args['max_height'] as num?)?.toDouble() ?? 1920.0;

    final picker = ImagePicker();
    try {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: 85,
        requestFullMetadata: false,
      );

      if (image == null) {
        return ToolResult.error('Camera cancelled — no photo taken.');
      }

      final bytes = await image.readAsBytes();
      final base64Data = base64Encode(bytes);

      return ToolResult.success(
        '{"type":"image","mimeType":"image/jpeg","data":"$base64Data",'
        '"size_bytes":${bytes.length},"path":"${image.path}"}',
      );
    } catch (e) {
      return ToolResult.error('Camera error: $e');
    }
  }
}

/// Records a video using the device camera and returns the local file path.
class CameraRecordVideoTool extends Tool {
  @override
  String get name => 'camera_record_video';

  @override
  String get description =>
      'Open the device camera to record a video. '
      'Returns the local file path of the recorded video. '
      'Optionally limits the maximum recording duration.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'max_duration_seconds': {
            'type': 'integer',
            'description':
                'Maximum video duration in seconds (default: 60, max: 600).',
            'minimum': 1,
            'maximum': 600,
          },
        },
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final maxDuration =
        (args['max_duration_seconds'] as num?)?.toInt() ?? 60;

    final picker = ImagePicker();
    try {
      final video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(seconds: maxDuration.clamp(1, 600)),
      );

      if (video == null) {
        return ToolResult.error('Camera cancelled — no video recorded.');
      }

      return ToolResult.success(
        '{"path":"${video.path}","name":"${video.name}"}',
      );
    } catch (e) {
      return ToolResult.error('Video recording error: $e');
    }
  }
}
