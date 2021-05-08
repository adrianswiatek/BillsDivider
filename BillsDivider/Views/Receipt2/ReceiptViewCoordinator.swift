import BillsDivider_ViewModel
import SwiftUI

public final class ReceiptViewCoordinator: ObservableObject {
    @Published
    private var destination: Destination

    private let addPositionViewModelFactory: () -> AddPositionViewModel
    private let editPositionViewModelFactory: () -> EditPositionViewModel
    private let addReductionViewModelFactory: () -> AddReductionViewModel
    private let editReductionViewModelFactory: () -> EditReductionViewModel

    public init(
        addPositionViewModelFactory: @escaping () -> AddPositionViewModel,
        editPositionViewModelFactory: @escaping () -> EditPositionViewModel,
        addReductionViewModelFactory: @escaping () -> AddReductionViewModel,
        editReductionViewModelFactory: @escaping () -> EditReductionViewModel
    ) {
        self.destination = .empty
        self.addPositionViewModelFactory = addPositionViewModelFactory
        self.editPositionViewModelFactory = editPositionViewModelFactory
        self.addReductionViewModelFactory = addReductionViewModelFactory
        self.editReductionViewModelFactory = editReductionViewModelFactory
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
        case .editReduction(let positionId):
            EditReductionView(editReductionViewModel(positionId))
        }
    }

    public func addPosition() {
        destination = .addPosition
    }

    public func editPosition(with positionId: UUID) {
        destination = .editPosition(positionId: positionId)
    }

    public func addReduction() {
        destination = .addReduction
    }

    public func editReduction(with positionId: UUID) {
        destination = .editReduction(positionId: positionId)
    }

    private func editPositionViewModel(_ positionId: UUID) -> EditPositionViewModel {
        let viewModel = editPositionViewModelFactory()
        viewModel.initializeWithPositionId(positionId)
        return viewModel
    }

    private func editReductionViewModel(_ positionId: UUID) -> EditReductionViewModel {
        let viewModel = editReductionViewModelFactory()
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
        case editReduction(positionId: UUID)
    }
}
