import BillsDivider_Model
import Combine
import Foundation
import SwiftUI

final class ViewModelFactory {
    private let receiptPositionService: ReceiptPositionService
    private let peopleService: PeopleService
    private let divider: PositionsDivider
    private let numberFormatter: NumberFormatter

    init(
        receiptPositionService: ReceiptPositionService,
        peopleService: PeopleService,
        divider: PositionsDivider,
        numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.peopleService = peopleService
        self.divider = divider
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var receiptViewModel: ReceiptViewModel {
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

    var summaryViewModel: SummaryViewModel {
        .init(
            receiptPositionService: receiptPositionService,
            peopleService: peopleService,
            divider: divider,
            numberFormatter: numberFormatter
        )
    }

    var settingsViewModel: SettingsViewModel {
        .init(peopleService: peopleService)
    }
}
