import BillsDivider_Model
import BillsDivider_ViewModel
import CoreData
import SwiftUI

class DependencyContainer {
    enum Configuration {
        case production
        case testing
    }

    private let configuration: Configuration
    private var dependencies: [String: Any]

    init(_ configuration: Configuration) {
        self.configuration = configuration
        self.dependencies = [:]

        self.registerOtherObjects()
        self.registerServices()
        self.registerViewModels()
        self.registerViews()
    }

    func register(_ type: Any.Type, as object: Any) {
        dependencies["\(type)"] = object
    }

    func resolve<T>(_ type: Any.Type) -> T {
        let dependencyName = "\(type)"
        guard let dependency = dependencies[dependencyName] else {
            preconditionFailure("Dependency: \(dependencyName) does not exist")
        }

        guard let typedDependency = dependency as? T else {
            preconditionFailure("Dependency \(dependencyName) exists, but has different type")
        }

        return typedDependency
    }

    private func registerOtherObjects() {
        register(
            NumberFormatter.self,
            as: NumberFormatter.twoFractionDigitsNumberFormatter
        )
        register(
            NSManagedObjectContext.self,
            as: configureCoreDataContext()
        )
    }

    private func registerServices() {
        register(
            PeopleService.self,
            as: PeopleServiceFactory.create(resolve(NSManagedObjectContext.self))
        )
        register(
            ReceiptPositionService.self,
            as: CoreDataReceiptPositionService(resolve(NSManagedObjectContext.self), resolve(PeopleService.self))
        )
        register(
            EditOverlayViewFactory.self,
            as: EditOverlayViewFactory(resolve(PeopleService.self), resolve(NumberFormatter.self))
        )
        register(
            PositionsDivider.self,
            as: PositionsDivider()
        )
    }

    private func registerViewModels() {
        register(
            ReceiptViewModel.self,
            as: ReceiptViewModel(
                resolve(ReceiptPositionService.self),
                resolve(PeopleService.self),
                resolve(NumberFormatter.self)
            )
        )
        register(
            SummaryViewModel.self,
            as: SummaryViewModel(
                resolve(ReceiptPositionService.self),
                resolve(PeopleService.self),
                resolve(PositionsDivider.self),
                resolve(NumberFormatter.self)
            )
        )
        register(
            SettingsViewModel.self,
            as: SettingsViewModel(resolve(PeopleService.self))
        )
    }

    private func registerViews() {
        register(
            ReceiptView.self,
            as: AnyView(ReceiptView(resolve(ReceiptViewModel.self), resolve(EditOverlayViewFactory.self)))
        )
        register(
            SummaryView.self,
            as: AnyView(SummaryView(resolve(SummaryViewModel.self)))
        )
        register(
            SettingsView.self,
            as: AnyView(SettingsView(resolve(SettingsViewModel.self)))
        )
        register(
            SettingsView2.self,
            as: AnyView(SettingsView2(resolve(SettingsViewModel.self)))
        )
        register(
            TabsView.self,
            as: AnyView(configureTabsView())
        )
    }

    private func configureCoreDataContext() -> NSManagedObjectContext {
        switch configuration {
        case .production:
            return SqliteCoreDataStack().context
        case .testing:
            return InMemoryCoreDataStack().context
        }
    }

    private func configureTabsView() -> TabsView {
        .init(items: [
            TabItem(title: "Receipt", imageName: "list.dash", view: resolve(ReceiptView.self)),
            TabItem(title: "Summary", imageName: "doc.text", view: resolve(SummaryView.self)),
            TabItem(title: "Settings", imageName: "hammer", view: resolve(SettingsView2.self))
        ])
    }
}
