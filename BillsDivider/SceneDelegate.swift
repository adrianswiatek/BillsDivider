import CoreData
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: getTabsView())
        self.window = window
        window.makeKeyAndVisible()
    }

    private func getTabsView() -> some View {
        let coreDataStack: CoreDataStack = SqliteCoreDataStack()
        let receiptPositionService: ReceiptPositionService =
            CoreDataReceiptPositionService(coreDataStack.context)
        let viewModelFactory = ViewModelFactory(
            receiptPositionService: receiptPositionService,
            divider: Divider(),
            numberFormatter: .twoFractionDigitsNumberFormatter
        )
        return TabsView(viewModelFactory: viewModelFactory)
    }
}
