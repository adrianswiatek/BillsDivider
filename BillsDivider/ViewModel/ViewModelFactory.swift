import Combine
import Foundation
import SwiftUI

struct ViewModelFactory {
    private let numberFormatter: NumberFormatter

    init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var receiptListViewModel: ReceiptListViewModel {
        ReceiptListViewModel(numberFormatter: numberFormatter)
    }

    func summaryViewModel(positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        SummaryViewModel(positions: positions, numberFormatter: numberFormatter)
    }

    func addOverlayViewModel(
        presenting: Binding<Bool>,
        receiptPosition: ReceiptPosition? = nil
    ) -> AddOverlayViewModel {
        AddOverlayViewModel(
            presenting: presenting,
            buyer: receiptPosition?.buyer ?? .me,
            owner: receiptPosition?.owner ?? .all,
            numberFormatter: numberFormatter
        )
    }
}
