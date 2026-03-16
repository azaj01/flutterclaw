import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {

    // Cold-launch: URL passed before the scene fully connects.
    override func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        super.scene(scene, willConnectTo: session, options: connectionOptions)
        if let url = connectionOptions.urlContexts.first?.url {
            _forwardURL(url, scene: scene)
        }
    }

    // Foreground/background: URL opened while scene is already running.
    override func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let url = URLContexts.first?.url else { return }
        _forwardURL(url, scene: scene)
    }

    private func _forwardURL(_ url: URL, scene: UIScene) {
        guard url.scheme == "flutterclaw" else { return }
        guard
            let windowScene = scene as? UIWindowScene,
            let flutterVC = windowScene.windows.first?.rootViewController
                as? FlutterViewController
        else { return }

        let channel = FlutterMethodChannel(
            name: "ai.flutterclaw/deeplinks",
            binaryMessenger: flutterVC.binaryMessenger
        )
        channel.invokeMethod("onDeepLink", arguments: url.absoluteString)
    }
}
