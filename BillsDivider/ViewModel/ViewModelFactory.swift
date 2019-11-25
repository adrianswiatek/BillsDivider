import Foundation
import SwiftUI

struct ViewModelFactory {
    private let numberFormatter: NumberFormatter

    init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var summaryViewModel: SummaryViewModel {
        SummaryViewModel(numberFormatter: numberFormatter)
    }

    var receiptListViewModel: ReceiptListViewModel {
        ReceiptListViewModel()
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
