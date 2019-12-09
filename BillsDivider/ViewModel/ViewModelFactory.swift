import Combine
import Foundation
import SwiftUI

final class ViewModelFactory {
    private let receiptPositionService: ReceiptPositionService
    private let divider: Divider
    private let numberFormatter: NumberFormatter

    init(
        receiptPositionService: ReceiptPositionService,
        divider: Divider,
        numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.divider = divider
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var receiptListViewModel: ReceiptListViewModel {
        ReceiptListViewModel(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)
    }

    func summaryViewModel(positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        SummaryViewModel(positions: positions, divider: divider, numberFormatter: numberFormatter)
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
