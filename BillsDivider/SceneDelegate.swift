import BillsDivider_Model
import CoreData
import SwiftUI
import UIKit

internal class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    internal func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let isUiTesting = CommandLine.arguments.contains("ui-testing")
        let dependencyContainer = DependencyContainer(isUiTesting ? .testing : .production)
        UIView.setAnimationsEnabled(!isUiTesting)

        let window = UIWindow(windowScene: windowScene)
        let rootView: some View = dependencyContainer.resolve(TabsView.self)
        window.rootViewController = UIHostingController(rootView: rootView)
        self.window = window
        window.makeKeyAndVisible()
    }
}
