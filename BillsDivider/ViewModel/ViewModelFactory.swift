import Combine
import Foundation
import SwiftUI

final class ViewModelFactory {
    private let receiptPositionService: ReceiptPositionService
    private let peopleService: PeopleService
    private let divider: Divider
    private let numberFormatter: NumberFormatter

    init(
        receiptPositionService: ReceiptPositionService,
        peopleService: PeopleService,
        divider: Divider,
        numberFormatter: NumberFormatter
    ) {
        self.receiptPositionService = receiptPositionService
        self.peopleService = peopleService
        self.divider = divider
        self.numberFormatter = numberFormatter
    }
}

extension ViewModelFactory {
    var receiptListViewModel: ReceiptListViewModel {
        .init(receiptPositionService: receiptPositionService, numberFormatter: numberFormatter)
    }

    func editOverlayViewModel(presentingParams: Binding<EditOverlayViewParams>) -> EditOverlayViewModel {
        let position = presentingParams.wrappedValue.position

        return .init(
            presenting: presentingParams.show,
            editOverlayStrategy: presentingParams.wrappedValue.mode == .adding
                ? AddingModeStrategy(receiptPosition: position)
                : EditingModeStrategy(receiptPosition: position, numberFormatter: numberFormatter),
            numberFormatter: numberFormatter
        )
    }

    func summaryViewModel(positions: AnyPublisher<[ReceiptPosition], Never>) -> SummaryViewModel {
        .init(positions: positions, divider: divider, numberFormatter: numberFormatter)
    }

    var settingsViewModel: SettingsViewModel {
        .init(peopleService: peopleService, maximumNumberOfPeople: 2)
    }
}
