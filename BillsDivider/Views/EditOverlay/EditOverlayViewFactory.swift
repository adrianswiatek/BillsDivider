import BillsDivider_ViewModel
import SwiftUI

internal final class EditOverlayViewFactory {
    private let viewModelFactory: EditOverlayViewModelFactory

    internal init(viewModelFactory: EditOverlayViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    internal func create(
        presenting: Binding<Bool>,
        parameters: EditOverlayViewParams,
        configure: (EditOverlayViewModel) -> Void
    ) -> EditOverlayView {
        let viewModel = viewModelFactory.create(presenting, parameters)
        configure(viewModel)
        return EditOverlayView(viewModel)
    }
}
