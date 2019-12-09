import Combine
import SwiftUI

struct PreviewFactory {
    private let viewModelFactory: ViewModelFactory

    init() {
        viewModelFactory = .init(
            receiptPositionService: InMemoryReceiptPositionService(),
            divider: .init(),
            numberFormatter: .twoFracionDigitsNumberFormatter
        )
    }
}

extension PreviewFactory {
    var tabsView: some View {
        TabsView(viewModelFactory: viewModelFactory)
    }

    var summaryView: some View {
        let positions = Empty<[ReceiptPosition], Never>().eraseToAnyPublisher()
        return SummaryView(viewModelFactory.summaryViewModel(positions: positions))
    }

    var receiptListView: some View {
        ReceiptListView(viewModelFactory.receiptListViewModel, viewModelFactory)
    }

    var addOverlayView: some View {
        AddOverlayView(viewModelFactory.addOverlayViewModel(presenting: .constant(true)))
    }
}
