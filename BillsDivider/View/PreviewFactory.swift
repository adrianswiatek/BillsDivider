import Combine
import SwiftUI

struct PreviewFactory {
    private let viewModelFactory: ViewModelFactory
    private let numberFormatter: NumberFormatter
    private let receiptListColumnWidth: CGFloat

    init() {
        receiptListColumnWidth = UIScreen.main.bounds.width / 3
        numberFormatter = .twoFractionDigitsNumberFormatter
        let peopleService: PeopleService = InMemoryPeopleService()
        viewModelFactory = .init(
            receiptPositionService: InMemoryReceiptPositionService(peopleService: peopleService),
            peopleService: peopleService,
            divider: .init(),
            numberFormatter: numberFormatter
        )
    }
}

extension PreviewFactory {
    var tabsView: some View {
        TabsView(viewModelFactory: viewModelFactory)
    }

    var receiptView: some View {
        ReceiptView(viewModelFactory.receiptViewModel, viewModelFactory)
    }

    var receiptHeaderView: some View {
        ReceiptHeaderView(receiptListColumnWidth)
    }

    var editOverlayView: some View {
        EditOverlayView(viewModelFactory.editOverlayViewModel(presentingParams: .constant(.shownAdding())))
    }

    var buyerSectionView: some View {
        BuyerSectionView(viewModelFactory.editOverlayViewModel(presentingParams: .constant(.shownAdding())))
    }

    var ownerSectionView: some View {
        OwnerSectionView(viewModelFactory.editOverlayViewModel(presentingParams: .constant(.shownAdding())))
    }

    var summaryView: some View {
        SummaryView(viewModelFactory.summaryViewModel)
    }

    var settingsView: some View {
        SettingsView(viewModelFactory.settingsViewModel)
    }
}
