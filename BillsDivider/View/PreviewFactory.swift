import Combine
import SwiftUI

struct PreviewFactory {
    private let viewModelFactory: ViewModelFactory
    private let numberFormatter: NumberFormatter
    private let receiptListColumnWidth: CGFloat

    init() {
        receiptListColumnWidth = UIScreen.main.bounds.width / 3
        numberFormatter = .twoFractionDigitsNumberFormatter
        viewModelFactory = .init(
            receiptPositionService: InMemoryReceiptPositionService(),
            divider: .init(),
            numberFormatter: numberFormatter
        )
    }
}

extension PreviewFactory {
    var tabsView: some View {
        TabsView(viewModelFactory: viewModelFactory)
    }

    var summaryView: some View {
        SummaryView(viewModelFactory.summaryViewModel(
            positions: Empty<[ReceiptPosition], Never>().eraseToAnyPublisher()
        ))
    }

    var receiptListView: some View {
        ReceiptListView(viewModelFactory.receiptListViewModel, viewModelFactory)
    }

    var receiptHeaderView: some View {
        ReceiptHeaderView(receiptListColumnWidth)
    }

    var editOverlayView: some View {
        EditOverlayView(viewModelFactory.editOverlayViewModel(presentingParams: .constant(.hidden)))
    }
}
