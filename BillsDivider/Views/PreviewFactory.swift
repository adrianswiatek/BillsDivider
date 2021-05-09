import BillsDivider_Model
import BillsDivider_ViewModel
import Combine
import SwiftUI

struct PreviewFactory {
    private let dependencyContainer: DependencyContainer

    init() {
        dependencyContainer = DependencyContainer(.testing)
    }
}

extension PreviewFactory {
    var tabsView: some View {
        TabsView(
            dependencyContainer.resolve(TabsViewCoordinator.self)
        )
    }

    var receiptView: some View {
        ReceiptView(
            dependencyContainer.resolve(ReceiptViewModel.self),
            dependencyContainer.resolve(ReceiptViewCoordinator.self)
        )
    }

    var addPositionView: some View {
        AddPositionView(
            dependencyContainer.resolve(AddPositionViewModel.self)
        )
    }

    var editPositionView: some View {
        EditPositionView(
            dependencyContainer.resolve(EditPositionViewModel.self)
        )
    }

    var moneySectionView: some View {
        MoneySectionView(
            .constant(dependencyContainer.resolve(MoneyViewModel.self))
        )
    }

    var addReductionView: some View {
        AddReductionView(
            dependencyContainer.resolve(AddReductionViewModel.self)
        )
    }

    var editReductionView: some View {
        EditReductionView(
            dependencyContainer.resolve(EditReductionViewModel.self)
        )
    }

    var summaryView: some View {
        SummaryView(
            dependencyContainer.resolve(SummaryViewModel.self)
        )
    }

    var settingsView: some View {
        SettingsView(
            dependencyContainer.resolve(SettingsViewModel.self)
        )
    }
}
