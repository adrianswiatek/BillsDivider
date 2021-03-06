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

        container.register(TabsViewCoordinator.self) {
            TabsViewCoordinator(
                $0.resolve(ReceiptViewCoordinator.self)!,
                $0.resolve(ReceiptViewModel.self)!,
                $0.resolve(SummaryViewModel.self)!,
                $0.resolve(SettingsViewModel.self)!
            )
        }
    }

    private func registerServices() {
        container.register(PeopleService.self) {
            PeopleServiceFactory.create($0.resolve(NSManagedObjectContext.self)!)
        }.inObjectScope(.container)

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
    }

    private func registerViewModels() {
        container.register(ReceiptViewModel.self) {
            ReceiptViewModel(
                $0.resolve(ReceiptPositionService.self)!,
                $0.resolve(PeopleService.self)!,
                $0.resolve(NumberFormatter.self)!
            )
        }

        container.register(ReceiptViewModel.self) {
            ReceiptViewModel(
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
}

public extension DependencyContainer {
    enum Configuration {
        case production
        case testing
    }
}
