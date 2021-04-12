import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

internal final class ReductionOverlayViewModelFactory {
    private let peopleService: PeopleService
    private let decimalParser: DecimalParser
    private let numberFormatter: NumberFormatter

    internal init(peopleService: PeopleService, decimalParser: DecimalParser, numberFormatter: NumberFormatter) {
        self.peopleService = peopleService
        self.decimalParser = decimalParser
        self.numberFormatter = numberFormatter
    }

    internal func create(with presenting: Binding<Bool>) -> ReductionOverlayViewModel {
        ReductionOverlayViewModel(
            presenting: presenting,
            priceViewModel: PriceViewModel(decimalParser: decimalParser, numberFormatter: numberFormatter),
            buyerViewModel: BuyerViewModel(peopleService),
            ownerViewModel: OwnerViewModel(peopleService),
            decimalParser: decimalParser
        )
    }
}
