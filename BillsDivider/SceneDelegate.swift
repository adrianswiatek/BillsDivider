import CoreData
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private var isUiTesting: Bool = false {
        didSet {
            UIView.setAnimationsEnabled(!isUiTesting)
        }
    }

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        isUiTesting = CommandLine.arguments.contains("ui-testing")

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = UIHostingController(rootView: getRootView())
        self.window = window
        window.makeKeyAndVisible()
    }

    private func getRootView() -> some View {
        let peopleService: PeopleService = preparePeopleService()
        let receiptPositionService: ReceiptPositionService =
            CoreDataReceiptPositionService(
                context: getCoreDataStack().context,
                mapper: .init(),
                peopleService: peopleService
        )
        let viewModelFactory = ViewModelFactory(
            receiptPositionService: receiptPositionService,
            peopleService: peopleService,
            divider: .init(),
            numberFormatter: .twoFractionDigitsNumberFormatter
        )
        return TabsView(viewModelFactory: viewModelFactory)
    }

    private func getCoreDataStack() -> CoreDataStack {
        isUiTesting ? InMemoryCoreDataStack() : SqliteCoreDataStack()
    }

    private func preparePeopleService() -> PeopleService {
        let peopleService = InMemoryPeopleService()
        let numberOfPeople = peopleService.getNumberOfPeople()
        let minimumNumberOfPeople = 2

        let initialPeople: [Person] = (numberOfPeople ..< minimumNumberOfPeople)
            .map { .withGeneratedName(forNumber: $0 + 1) }

        if !initialPeople.isEmpty {
            peopleService.updatePeople(initialPeople)
        }

        return peopleService
    }
}
