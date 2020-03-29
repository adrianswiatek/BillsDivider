import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

internal final class EditOverlayViewModelFactory {
    private let peopleService: PeopleService
    private let decimalParser: DecimalParser
    private let numberFormatter: NumberFormatter

    internal init(
        peopleService: PeopleService,
        decimalParser: DecimalParser,
        numberFormatter: NumberFormatter
    ) {
        self.peopleService = peopleService
        self.decimalParser = decimalParser
        self.numberFormatter = numberFormatter
    }

    internal func create(
        _ presenting: Binding<Bool>,
        _ parameters: EditOverlayViewParams
    ) -> EditOverlayViewModel {
        let popoverViewModel = discountPopoverViewModel

        return EditOverlayViewModel(
            presenting: presenting,
            priceViewModel: priceViewModel,
            discountViewModel: discountViewModel(popoverViewModel),
            discountPopoverViewModel: popoverViewModel,
            editOverlayState: editOverlayState(parameters),
            buyerViewModel: buyerViewModel,
            ownerViewModel: ownerViewModel,
            decimalParser: decimalParser
        )
    }

    private var priceViewModel: PriceViewModel {
        PriceViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)
    }

    private func discountViewModel(_ popoverViewModel: DiscountPopoverViewModel) -> DiscountViewModel {
        DiscountViewModel(discountPopoverViewModel: popoverViewModel, decimalParser: decimalParser)
    }

    private var discountPopoverViewModel: DiscountPopoverViewModel {
        DiscountPopoverViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter)
    }

    private func editOverlayState(_ parameters: EditOverlayViewParams) -> EditOverlayState {
        parameters.mode == .adding
            ? AddingModeState(receiptPosition: parameters.position)
            : EditingModeState(receiptPosition: parameters.position, numberFormatter: numberFormatter)
    }

    private var buyerViewModel: BuyerViewModel {
        BuyerViewModel(peopleService: peopleService)
    }

    private var ownerViewModel: OwnerViewModel {
        OwnerViewModel(peopleService: peopleService)
    }
}
