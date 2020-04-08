import BillsDivider_ViewModel
import SwiftUI

internal final class EditOverlayViewFactory {
    private let viewModelFactory: EditOverlayViewModelFactory
    private let priceTextFieldFactory: PriceTextFieldFactory

    internal init(viewModelFactory: EditOverlayViewModelFactory, priceTextFieldFactory: PriceTextFieldFactory) {
        self.viewModelFactory = viewModelFactory
        self.priceTextFieldFactory = priceTextFieldFactory
    }

    internal func create(
        presenting: Binding<Bool>,
        parameters: EditOverlayViewParams,
        configure: (EditOverlayViewModel) -> Void
    ) -> EditOverlayView {
        let viewModel = viewModelFactory.create(presenting, parameters)
        configure(viewModel)
        return EditOverlayView(viewModel, priceTextFieldFactory)
    }
}
