import BillsDivider_Model
import BillsDivider_ViewModel
import CoreData
import SwiftUI
import Swinject

public final class DependencyContainer {
    private let container: Container
    private let configuration: Configuration

    public init(_ configuration: Configuration) {
        self.container = Container()
        self.configuration = configuration

        self.registerOtherObjects()
        self.registerServices()
        self.registerViewModels()
        self.registerViews()
    }

    public func resolve<T>(_ dependency: T.Type) -> T {
        container.resolve(dependency)!
    }

    private func registerOtherObjects() {
        container.register(NumberFormatter.self) { _ in
            .twoFractionDigitsNumberFormatter
        }

        container.register(NSManagedObjectContext.self) { _ in
            switch self.configuration {
            case .production:
                return SqliteCoreDataStack().context
            case .testing:
                return InMemoryCoreDataStack().context
            }
        }.inObjectScope(.container)

        container.register(ReceiptViewCoordinator.self) { resolver in
            ReceiptViewCoordinator(
                addPositionViewModelFactory: { resolver.resolve(AddPositionViewModel.self)! },
                editPositionViewModelFactory: { resolver.resolve(EditPositionViewModel.self)! },
                addReductionViewModelFactory: { resolver.resolve(AddReductionViewModel.self)! },
                editReductionViewModelFactory: { resolver.resolve(EditReductionViewModel.self)! }
            )
        }
    }

    private func registerServices() {
        container.register(PeopleService.self) {
            PeopleServiceFactory.create($0.resolve(NSManagedObjectContext.self)!)
        }

        container.register(ReceiptPositionService.self) {
            CoreDataReceiptPositionService(
                $0.resolve(NSManagedObjectContext.self)!,
                $0.resolve(PeopleService.self)!
            )
        }.inObjectScope(.container)

        container.register(DecimalParser.self) { _ in
            DecimalParser()
        }

        container.register(PositionsDivider.self) { _ in
            PositionsDivider()
        }

        container.register(EditOverlayViewModelFactory.self) {
            EditOverlayViewModelFactory(
                peopleService: $0.resolve(PeopleService.self)!,
                decimalParser: $0.resolve(DecimalParser.self)!,
                numberFormatter: $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(EditOverlayViewFactory.self) {
            EditOverlayViewFactory(
                viewModelFactory: $0.resolve(EditOverlayViewModelFactory.self)!
            )
        }

        container.register(ReductionOverlayViewModelFactory.self) {
            ReductionOverlayViewModelFactory(
                peopleService: $0.resolve(PeopleService.self)!,
                decimalParser: $0.resolve(DecimalParser.self)!,
                numberFormatter: $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(ReductionOverlayViewFactory.self) {
            ReductionOverlayViewFactory(
                viewModelFactory: $0.resolve(ReductionOverlayViewModelFactory.self)!
            )
        }
    }

    private func registerViewModels() {
        container.register(ReceiptViewModel.self) {
            ReceiptViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(NumberFormatter.self)!,
                self.configuration == .testing
            )
        }

        container.register(ReceiptViewModel2.self) {
            ReceiptViewModel2(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(AddPositionViewModel.self) {
            AddPositionViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(DecimalParser.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }.inObjectScope(.container)

        container.register(EditPositionViewModel.self) {
            EditPositionViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(DecimalParser.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(AddReductionViewModel.self) {
            AddReductionViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(DecimalParser.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(EditReductionViewModel.self) {
            EditReductionViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(DecimalParser.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(SummaryViewModel.self) {
            SummaryViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(PositionsDivider.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(SettingsViewModel.self) {
            SettingsViewModel(
                $0.resolve(PeopleService.self)!,
                [.green, .blue, .purple, .pink, .red, .orange]
            )
        }

        container.register(PriceViewModel.self) {
            PriceViewModel(
                decimalParser: $0.resolve(DecimalParser.self)!,
                numberFormatter: $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(DiscountPopoverViewModel.self) {
            DiscountPopoverViewModel(
                decimalParser: $0.resolve(DecimalParser.self)!,
                numberFormatter: $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(DiscountViewModel.self) {
            DiscountViewModel(
                discountPopoverViewModel: $0.resolve(DiscountPopoverViewModel.self)!,
                decimalParser: $0.resolve(DecimalParser.self)!
            )
        }
    }

    private func registerViews() {
        container.register(ReceiptView.self) {
            ReceiptView(
                $0.resolve(ReceiptViewModel.self)!,
                $0.resolve(EditOverlayViewFactory.self)!,
                $0.resolve(ReductionOverlayViewFactory.self)!
            )
        }

        container.register(ReceiptView2.self) {
            ReceiptView2(
                $0.resolve(ReceiptViewModel2.self)!,
                $0.resolve(ReceiptViewCoordinator.self)!
            )
        }

        container.register(AddPositionView.self) {
            AddPositionView(
                $0.resolve(AddPositionViewModel.self)!
            )
        }

        container.register(EditPositionView.self) {
            EditPositionView(
                $0.resolve(EditPositionViewModel.self)!
            )
        }

        container.register(SummaryView.self) {
            SummaryView(
                $0.resolve(SummaryViewModel.self)!
            )
        }

        container.register(SettingsView.self) {
            SettingsView(
                $0.resolve(SettingsViewModel.self)!
            )
        }

        container.register(TabsView.self) {
            TabsView(items: [
                TabItem(title: "Receipt", imageName: "list.dash", view: AnyView($0.resolve(ReceiptView2.self)!)),
                TabItem(title: "Summary", imageName: "doc.text", view: AnyView($0.resolve(SummaryView.self)!)),
                TabItem(title: "Settings", imageName: "hammer", view: AnyView($0.resolve(SettingsView.self)!))
            ])
        }
    }
}

public extension DependencyContainer {
    enum Configuration {
        case production
        case testing
    }
}
