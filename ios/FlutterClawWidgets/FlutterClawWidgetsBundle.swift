import SwiftUI
import WidgetKit

@main
struct FlutterClawWidgetsBundle: WidgetBundle {
  @WidgetBundleBuilder
  var body: some Widget {
    if #available(iOS 16.2, *) {
      GatewayLiveActivity()
    }
  }
}
