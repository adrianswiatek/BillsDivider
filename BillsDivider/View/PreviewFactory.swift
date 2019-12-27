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
            receiptPositionService: InMemoryReceiptPositionService(),
            receiptPositionService2: InMemoryReceiptPositionService2(peopleService: peopleService),
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

    var receiptListView: some View {
        ReceiptListView(viewModelFactory.receiptListViewModel, viewModelFactory)
    }

    var receiptHeaderView: some View {
        ReceiptHeaderView(receiptListColumnWidth)
    }

    var editOverlayView: some View {
        EditOverlayView(viewModelFactory.editOverlayViewModel(presentingParams: .constant(.shownAdding())))
    }

    var editOverlayView2: some View {
        EditOverlayView2(viewModelFactory.editOverlayViewModel2(presentingParams: .constant(.shownAdding())))
    }

    var buyerSectionView: some View {
        BuyerSectionView(buyer: .constant(.me))
    }

    var ownerSectionView: some View {
        OwnerSectionView(owner: .constant(.all))
    }

    var buyerSectionView2: some View {
        BuyerSectionView2(viewModelFactory.editOverlayViewModel2(presentingParams: .constant(.shownAdding())))
    }

    var ownerSectionView2: some View {
        OwnerSectionView2(viewModelFactory.editOverlayViewModel2(presentingParams: .constant(.shownAdding())))
    }

    var summaryView: some View {
        SummaryView(viewModelFactory.summaryViewModel(
            positions: Empty<[ReceiptPosition], Never>().eraseToAnyPublisher()
        ))
    }

    var settingsView: some View {
        SettingsView(viewModelFactory.settingsViewModel)
    }
}
