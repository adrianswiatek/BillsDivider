import BillsDivider_ViewModel
import SwiftUI

internal final class EditOverlayViewFactory {
    private let viewModelFactory: EditOverlayViewModelFactory

    internal init(viewModelFactory: EditOverlayViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    internal func create(
        presentingParams: Binding<EditOverlayViewParams>,
        configure: (EditOverlayViewModel) -> Void
    ) -> EditOverlayView {
        let viewModel = viewModelFactory.create(with: presentingParams)
        configure(viewModel)
        return EditOverlayView(viewModel)
    }
}
