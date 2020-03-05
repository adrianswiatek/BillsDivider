import BillsDivider_Model
import BillsDivider_ViewModel
import Combine
import SwiftUI

struct PreviewFactory {
    private let dependencyContainer: DependencyContainer
    private let receiptListColumnWidth: CGFloat

    init() {
        receiptListColumnWidth = UIScreen.main.bounds.width / 3
        dependencyContainer = DependencyContainer(.testing)
    }
}

extension PreviewFactory {
    var tabsView: some View {
        dependencyContainer.resolve(TabsView.self) as AnyView
    }

    var receiptView: some View {
        dependencyContainer.resolve(ReceiptView.self) as AnyView
    }

    var receiptHeaderView: some View {
        ReceiptHeaderView(receiptListColumnWidth)
    }

    var editOverlayView: some View {
        let viewFactory: EditOverlayViewFactory = dependencyContainer.resolve(EditOverlayViewFactory.self)
        return viewFactory.create(presentingParams: .constant(.shownAdding()), configure: { _ in })
    }

    var buyerSectionView: some View {
        let viewModel = EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: AddingModeStrategy(receiptPosition: .empty),
            peopleService: dependencyContainer.resolve(PeopleService.self),
            decimalParser: dependencyContainer.resolve(DecimalParser.self),
            numberFormatter: dependencyContainer.resolve(NumberFormatter.self)
        )
        return BuyerSectionView(viewModel)
    }

    var ownerSectionView: some View {
        let viewModel = EditOverlayViewModel(
            presenting: .constant(true),
            editOverlayStrategy: AddingModeStrategy(receiptPosition: .empty),
            peopleService: dependencyContainer.resolve(PeopleService.self),
            decimalParser: dependencyContainer.resolve(DecimalParser.self),
            numberFormatter: dependencyContainer.resolve(NumberFormatter.self)
        )
        return OwnerSectionView(viewModel)
    }

    var summaryView: some View {
        dependencyContainer.resolve(SummaryView.self) as AnyView
    }

    var settingsView: some View {
        dependencyContainer.resolve(SettingsView.self) as AnyView
    }
}
