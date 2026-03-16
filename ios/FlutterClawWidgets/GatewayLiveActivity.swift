import ActivityKit
import SwiftUI
import WidgetKit

private let appGroupId = "group.ai.flutterclaw"
private let sharedDefault = UserDefaults(suiteName: appGroupId)!

@available(iOS 16.2, *)
struct GatewayLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: LiveActivitiesAppAttributes.self) { context in
      LockScreenView(attributes: context.attributes)
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          GatewayLeadingView(attributes: context.attributes)
        }
        DynamicIslandExpandedRegion(.trailing) {
          GatewayConnectionsView(attributes: context.attributes)
        }
        DynamicIslandExpandedRegion(.bottom) {
          GatewayBottomView(attributes: context.attributes)
        }
      } compactLeading: {
        let isRunning = gatewayIsRunning(attributes: context.attributes)
        let error = gatewayError(attributes: context.attributes)
        let status = gatewayStatus(attributes: context.attributes)
        Circle()
          .fill(statusColor(isRunning: isRunning, error: error, status: status))
          .frame(width: 8, height: 8)
          .padding(.leading, 2)
      } compactTrailing: {
        let error = gatewayError(attributes: context.attributes)
        if !(error ?? "").isEmpty {
          Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.red)
        } else {
          HStack(spacing: 2) {
            Image(systemName: "sparkles")
              .font(.system(size: 9, weight: .medium))
            Text(formatTokens(gatewayTokensProcessed(attributes: context.attributes)))
              .font(.system(size: 11, weight: .semibold, design: .rounded).monospacedDigit())
          }
          .padding(.trailing, 2)
        }
      } minimal: {
        let isRunning = gatewayIsRunning(attributes: context.attributes)
        let error = gatewayError(attributes: context.attributes)
        let status = gatewayStatus(attributes: context.attributes)
        Circle()
          .fill(statusColor(isRunning: isRunning, error: error, status: status))
          .frame(width: 8, height: 8)
      }
    }
  }
}

// MARK: - UserDefaults helpers (data written by live_activities plugin)

private func gatewayIsRunning(attributes: LiveActivitiesAppAttributes) -> Bool {
  sharedDefault.string(forKey: attributes.prefixedKey("isRunning")) == "true"
}

private func gatewayTokensProcessed(attributes: LiveActivitiesAppAttributes) -> Int {
  Int(sharedDefault.string(forKey: attributes.prefixedKey("tokensProcessed")) ?? "0") ?? 0
}

private func formatTokens(_ n: Int) -> String {
  if n >= 1_000_000 { return String(format: "%.1fM", Double(n) / 1_000_000) }
  if n >= 1_000    { return String(format: "%.1fk", Double(n) / 1_000) }
  return "\(n)"
}

private func gatewayUptimeSeconds(attributes: LiveActivitiesAppAttributes) -> Int {
  Int(sharedDefault.string(forKey: attributes.prefixedKey("uptimeSeconds")) ?? "0") ?? 0
}

private func gatewayModel(attributes: LiveActivitiesAppAttributes) -> String {
  sharedDefault.string(forKey: attributes.prefixedKey("model")) ?? ""
}

private func gatewaySessionCount(attributes: LiveActivitiesAppAttributes) -> Int {
  Int(sharedDefault.string(forKey: attributes.prefixedKey("sessionCount")) ?? "0") ?? 0
}

private func gatewayError(attributes: LiveActivitiesAppAttributes) -> String? {
  let error = sharedDefault.string(forKey: attributes.prefixedKey("errorMessage")) ?? ""
  return error.isEmpty ? nil : error
}

private func gatewayStatus(attributes: LiveActivitiesAppAttributes) -> String {
  sharedDefault.string(forKey: attributes.prefixedKey("status")) ?? "stopped"
}

private func formatUptime(_ seconds: Int) -> String {
  guard seconds > 0 else { return "0m" }
  let hours = seconds / 3600
  let minutes = (seconds % 3600) / 60
  if hours > 0 { return "\(hours)h \(minutes)m" }
  return "\(minutes)m"
}

// MARK: - Status helpers

private func statusColor(isRunning: Bool, error: String?, status: String) -> Color {
  guard (error ?? "").isEmpty else { return .red }
  if status == "starting" || status == "retrying" { return .orange }
  return isRunning ? Color(red: 0.20, green: 0.78, blue: 0.35) : Color.secondary
}

private func statusLabel(isRunning: Bool, error: String?, status: String) -> String {
  guard (error ?? "").isEmpty else { return "Error" }
  switch status {
  case "starting": return "Starting"
  case "retrying": return "Retrying"
  default: return isRunning ? "Running" : "Stopped"
  }
}

private func statusIcon(isRunning: Bool, error: String?, status: String) -> String {
  guard (error ?? "").isEmpty else { return "exclamationmark.triangle.fill" }
  if status == "starting" || status == "retrying" { return "circle.dotted" }
  return isRunning ? "checkmark.circle.fill" : "minus.circle"
}

/// Strips the date suffix from model names, e.g. "claude-3-5-sonnet-20241022" → "claude-3-5-sonnet"
private func shortModelName(_ name: String) -> String {
  guard !name.isEmpty else { return "—" }
  let parts = name.components(separatedBy: "-")
  // Last component is a date (8 digits) — remove it
  if let last = parts.last, last.count == 8, Int(last) != nil {
    return parts.dropLast().joined(separator: "-")
  }
  return name
}

// MARK: - Lock Screen Banner

@available(iOS 16.2, *)
struct LockScreenView: View {
  let attributes: LiveActivitiesAppAttributes

  var body: some View {
    let isRunning = gatewayIsRunning(attributes: attributes)
    let error = gatewayError(attributes: attributes)
    let status = gatewayStatus(attributes: attributes)
    let model = gatewayModel(attributes: attributes)
    let connections = gatewayTokensProcessed(attributes: attributes)
    let sessions = gatewaySessionCount(attributes: attributes)
    let uptime = gatewayUptimeSeconds(attributes: attributes)
    let color = statusColor(isRunning: isRunning, error: error, status: status)

    VStack(alignment: .leading, spacing: 10) {

      // ── Header row ────────────────────────────────────────────
      HStack(alignment: .center, spacing: 0) {
        // App identity
        HStack(spacing: 7) {
          Image(systemName: "point.3.connected.trianglepath.dotted")
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(color)
          Text("FlutterClaw")
            .font(.system(size: 15, weight: .semibold, design: .rounded))
            .foregroundStyle(.primary)
        }

        Spacer()

        // Status pill
        HStack(spacing: 4) {
          Image(systemName: statusIcon(isRunning: isRunning, error: error, status: status))
            .font(.system(size: 10, weight: .semibold))
          Text(statusLabel(isRunning: isRunning, error: error, status: status))
            .font(.system(size: 11, weight: .semibold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(color.opacity(0.14), in: Capsule())
      }

      // ── Content row ───────────────────────────────────────────
      if let errorMsg = error {
        HStack(spacing: 6) {
          Image(systemName: "exclamationmark.triangle.fill")
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.red)
          Text(errorMsg)
            .font(.system(size: 12))
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .truncationMode(.tail)
        }
      } else {
        HStack(alignment: .center, spacing: 0) {
          // Model name
          Label {
            Text(shortModelName(model))
              .font(.system(size: 12, weight: .medium, design: .monospaced))
              .lineLimit(1)
              .minimumScaleFactor(0.8)
              .foregroundStyle(.primary)
          } icon: {
            Image(systemName: "cpu")
              .font(.system(size: 10, weight: .medium))
              .foregroundStyle(.secondary)
          }

          Spacer(minLength: 10)

          HStack(spacing: 14) {
            _StatPill(icon: "sparkles", value: formatTokens(connections))
            _StatPill(icon: "doc.text", value: "\(sessions)")
            _StatPill(icon: "clock", value: formatUptime(uptime))
          }
        }
      }
    }
  }
}

// Small icon + value pair used in the lock screen stats row
@available(iOS 16.2, *)
private struct _StatPill: View {
  let icon: String
  let value: String

  var body: some View {
    HStack(spacing: 3) {
      Image(systemName: icon)
        .font(.system(size: 10, weight: .medium))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.system(size: 12, weight: .semibold, design: .rounded).monospacedDigit())
        .foregroundStyle(.primary)
    }
  }
}

// MARK: - Dynamic Island expanded regions

@available(iOS 16.2, *)
private struct GatewayLeadingView: View {
  let attributes: LiveActivitiesAppAttributes
  var body: some View {
    let isRunning = gatewayIsRunning(attributes: attributes)
    let error = gatewayError(attributes: attributes)
    let status = gatewayStatus(attributes: attributes)
    let color = statusColor(isRunning: isRunning, error: error, status: status)

    HStack(spacing: 6) {
      Circle()
        .fill(color)
        .frame(width: 9, height: 9)
      Text(statusLabel(isRunning: isRunning, error: error, status: status))
        .font(.system(size: 12, weight: .semibold, design: .rounded))
        .foregroundStyle(color)
    }
    .padding(.leading, 4)
  }
}

@available(iOS 16.2, *)
private struct GatewayConnectionsView: View {
  let attributes: LiveActivitiesAppAttributes
  var body: some View {
    HStack(spacing: 3) {
      Image(systemName: "sparkles")
        .font(.system(size: 11, weight: .medium))
        .foregroundStyle(.secondary)
      Text(formatTokens(gatewayTokensProcessed(attributes: attributes)))
        .font(.system(size: 13, weight: .semibold, design: .rounded).monospacedDigit())
        .foregroundStyle(.primary)
    }
    .padding(.trailing, 4)
  }
}

@available(iOS 16.2, *)
private struct GatewayBottomView: View {
  let attributes: LiveActivitiesAppAttributes
  var body: some View {
    let model = gatewayModel(attributes: attributes)
    let sessions = gatewaySessionCount(attributes: attributes)
    let uptime = gatewayUptimeSeconds(attributes: attributes)
    let connections = gatewayTokensProcessed(attributes: attributes)

    VStack(alignment: .leading, spacing: 0) {
      Divider()
        .opacity(0.2)
        .padding(.bottom, 8)

      HStack(alignment: .center, spacing: 0) {
        // Model name — primary focus of the expanded view
        HStack(spacing: 5) {
          Image(systemName: "cpu")
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.secondary)
          Text(shortModelName(model))
            .font(.system(size: 13, weight: .semibold, design: .monospaced))
            .foregroundStyle(.primary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
        }

        Spacer(minLength: 12)

        // Stats
        HStack(spacing: 10) {
          HStack(spacing: 3) {
            Image(systemName: "sparkles")
              .font(.system(size: 10, weight: .medium))
              .foregroundStyle(.secondary)
            Text(formatTokens(connections))
              .font(.system(size: 12, weight: .semibold, design: .rounded).monospacedDigit())
              .foregroundStyle(.primary)
          }
          HStack(spacing: 3) {
            Image(systemName: "doc.text")
              .font(.system(size: 10, weight: .medium))
              .foregroundStyle(.secondary)
            Text("\(sessions)")
              .font(.system(size: 12, weight: .semibold, design: .rounded).monospacedDigit())
              .foregroundStyle(.primary)
          }
          HStack(spacing: 3) {
            Image(systemName: "clock")
              .font(.system(size: 10, weight: .medium))
              .foregroundStyle(.secondary)
            Text(formatUptime(uptime))
              .font(.system(size: 12, weight: .semibold, design: .rounded).monospacedDigit())
              .foregroundStyle(.primary)
          }
        }
      }
    }
    .padding(.horizontal, 4)
  }
}
