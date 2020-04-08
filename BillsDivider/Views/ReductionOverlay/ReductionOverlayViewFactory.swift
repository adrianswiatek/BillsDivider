import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

internal final class ReductionOverlayViewFactory {
    private let viewModelFactory: ReductionOverlayViewModelFactory
    private let priceTextFieldFactory: PriceTextFieldFactory

    internal init(viewModelFactory: ReductionOverlayViewModelFactory, priceTextFieldFactory: PriceTextFieldFactory) {
        self.viewModelFactory = viewModelFactory
        self.priceTextFieldFactory = priceTextFieldFactory
    }

    internal func create(
        presenting: Binding<Bool>,
        configure: (ReductionOverlayViewModel) -> Void
    ) -> ReductionOverlayView {
        let viewModel = viewModelFactory.create(with: presenting)
        configure(viewModel)
        return ReductionOverlayView(viewModel, priceTextFieldFactory)
    }
}
