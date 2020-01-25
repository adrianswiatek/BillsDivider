import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

final class EditOverlayViewFactory {
    private let peopleService: PeopleService
    private let numberFormatter: NumberFormatter

    init(_ peopleService: PeopleService, _ numberFormatter: NumberFormatter) {
        self.peopleService = peopleService
        self.numberFormatter = numberFormatter
    }

    func create(
        presentingParams: Binding<EditOverlayViewParams>,
        configure: (EditOverlayViewModel) -> Void
    ) -> EditOverlayView {
        let viewModel = self.viewModel(presentingParams)
        configure(viewModel)
        return EditOverlayView(viewModel)
    }

    private func viewModel(_ presentingParams: Binding<EditOverlayViewParams>) -> EditOverlayViewModel {
        .init(
            presenting: presentingParams.show,
            editOverlayStrategy: editOverlayStrategy(presentingParams.wrappedValue),
            peopleService: peopleService,
            numberFormatter: numberFormatter
        )
    }

    private func editOverlayStrategy(_ params: EditOverlayViewParams) -> EditOverlayStrategy {
        params.mode == .adding
            ? AddingModeStrategy(receiptPosition: params.position)
            : EditingModeStrategy(receiptPosition: params.position, numberFormatter: numberFormatter)
    }
}