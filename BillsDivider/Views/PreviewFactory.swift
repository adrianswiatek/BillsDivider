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
        dependencyContainer.resolve(TabsView.self)
    }

    var receiptView: some View {
        dependencyContainer.resolve(ReceiptView.self)
    }

    var addPositionView: some View {
        dependencyContainer.resolve(AddPositionView.self)
    }

    var editPositionView: some View {
        dependencyContainer.resolve(EditPositionView.self)
    }

    var addReductionView: some View {
        dependencyContainer.resolve(AddReductionView.self)
    }

    var editReductionView: some View {
        dependencyContainer.resolve(EditReductionView.self)
    }

    var summaryView: some View {
        dependencyContainer.resolve(SummaryView.self)
    }

    var settingsView: some View {
        dependencyContainer.resolve(SettingsView.self)
    }
}
