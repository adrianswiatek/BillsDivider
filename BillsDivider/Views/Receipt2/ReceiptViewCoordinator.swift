import BillsDivider_ViewModel
import SwiftUI

public final class ReceiptViewCoordinator: ObservableObject {
    @Published
    private var destination: Destination

    private let addPositionViewModelFactory: () -> AddPositionViewModel
    private let editPositionViewModelFactory: () -> EditPositionViewModel
    private let addReductionViewModelFactory: () -> AddReductionViewModel

    public init(
        addPositionViewModelFactory: @escaping () -> AddPositionViewModel,
        editPositionViewModelFactory: @escaping () -> EditPositionViewModel,
        addReductionViewModelFactory: @escaping () -> AddReductionViewModel
    ) {
        self.destination = .empty
        self.addPositionViewModelFactory = addPositionViewModelFactory
        self.editPositionViewModelFactory = editPositionViewModelFactory
        self.addReductionViewModelFactory = addReductionViewModelFactory
    }

    @ViewBuilder
    public func destinationView() -> some View {
        switch destination {
        case .empty:
            EmptyView()
        case .addPosition:
            AddPositionView(addPositionViewModelFactory())
        case .addReduction:
            AddReductionView(addReductionViewModelFactory())
        case .editPosition(let positionId):
            EditPositionView(editPositionViewModel(positionId))
        }
    }

    public func addPosition() {
        destination = .addPosition
    }

    public func editPosition(with id: UUID) {
        destination = .editPosition(positionId: id)
    }

    public func addReduction() {
        destination = .addReduction
    }

    private func editPositionViewModel(_ positionId: UUID) -> EditPositionViewModel {
        let viewModel = editPositionViewModelFactory()
        viewModel.initializeWithPositionId(positionId)
        return viewModel
    }
}

private extension ReceiptViewCoordinator {
    enum Destination {
        case empty
        case addPosition
        case addReduction
        case editPosition(positionId: UUID)
    }
}
