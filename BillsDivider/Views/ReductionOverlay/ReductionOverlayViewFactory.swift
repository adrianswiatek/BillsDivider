import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

internal final class ReductionOverlayViewFactory {
    private let viewModelFactory: ReductionOverlayViewModelFactory

    internal init(viewModelFactory: ReductionOverlayViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    internal func create(
        presenting: Binding<Bool>,
        configure: (ReductionOverlayViewModel) -> Void
    ) -> ReductionOverlayView {
        let viewModel = viewModelFactory.create(with: presenting)
        configure(viewModel)
        return ReductionOverlayView(viewModel)
    }
}
