import Combine
import Foundation
import SwiftUI

struct ViewModelFactory {
    private let numberFormatter: NumberFormatter
    private let billsDivider: BillsDivider

    init(billsDivider: BillsDivider, numberFormatter: NumberFormatter) {
        self.billsDivider = billsDivider
        self.numberFormatter = numberFormatter
    }

    static var `default`: ViewModelFactory {
        .init(billsDivider: .init(), numberFormatter: .twoFracionDigitsNumberFormatter)
    }
}

extension ViewModelFactory {
    var receiptListViewModel: ReceiptListViewModel {
        ReceiptListViewModel(numberFormatter: numberFormatter)
    }

    func summaryViewModel(positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        SummaryViewModel(
            positions: positions,
            billsDivider: billsDivider,
            numberFormatter: numberFormatter
        )
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
