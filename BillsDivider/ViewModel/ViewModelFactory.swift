import Combine
import Foundation
import SwiftUI

final class ViewModelFactory {
    private let receiptPositionService: ReceiptPositionService
    private let receiptPositionService2: ReceiptPositionService2
    private let peopleService: PeopleService
    private let divider: Divider2
    private let numberFormatter: NumberFormatter

    init(
        receiptPositionService: ReceiptPositionService,
        receiptPositionService2: ReceiptPositionService2,
        peopleService: PeopleService,
        divider: Divider2,
        numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.receiptPositionService2 = receiptPositionService2
        self.peopleService = peopleService
        self.divider = divider
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var receiptViewModel: ReceiptViewModel {
        .init(receiptPositionService: receiptPositionService2, numberFormatter: numberFormatter)
    }

    var receiptListViewModel: ReceiptListViewModel {
        .init(
            receiptPositionService: receiptPositionService,
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
    }

    func editOverlayViewModel(presentingParams: Binding<EditOverlayViewParams>) -> EditOverlayViewModel {
        let position = presentingParams.wrappedValue.position

        return .init(
            presenting: presentingParams.show,
            editOverlayStrategy: presentingParams.wrappedValue.mode == .adding
                ? AddingModeStrategy(receiptPosition: position)
                : EditingModeStrategy(receiptPosition: position, numberFormatter: numberFormatter),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
    }

    func editOverlayViewModel2(presentingParams: Binding<EditOverlayViewParams2>) -> EditOverlayViewModel2 {
        let position = presentingParams.wrappedValue.position

        return .init(
            presenting: presentingParams.show,
            editOverlayStrategy: presentingParams.wrappedValue.mode == .adding
                ? AddingModeStrategy2(receiptPosition: position)
                : EditingModeStrategy2(receiptPosition: position, numberFormatter: numberFormatter),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
    }

    func summaryViewModel(positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        .init(
            receiptPositionService: receiptPositionService2,
            peopleService: peopleService,
            divider: divider,
            numberFormatter: numberFormatter
        )
    }

    var settingsViewModel: SettingsViewModel {
        .init(peopleService: peopleService)
    }
}
