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
        let context: NSManagedObjectContext = getCoreDataStack().context
        let peopleService: PeopleService = preparePeopleService(context)

        let viewModelFactory = ViewModelFactory(
            receiptPositionService: prepareReceiptPositionService(context, peopleService),
            peopleService: peopleService,
            divider: .init(),
            numberFormatter: .twoFractionDigitsNumberFormatter
        )

        return TabsView(viewModelFactory: viewModelFactory)
    }

    private func getCoreDataStack() -> CoreDataStack {
        isUiTesting ? InMemoryCoreDataStack() : SqliteCoreDataStack()
    }

    private func prepareReceiptPositionService(
        _ context: NSManagedObjectContext,
        _ peopleService: PeopleService
    ) -> ReceiptPositionService {
        CoreDataReceiptPositionService(context: context, peopleService: peopleService)
    }

    private func preparePeopleService(_ context: NSManagedObjectContext) -> PeopleService {
        let peopleService = CoreDataPeopleService(context: context, maximumNumberOfPeople: 2)
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
