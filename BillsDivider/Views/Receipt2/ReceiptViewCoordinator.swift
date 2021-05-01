import BillsDivider_ViewModel
import SwiftUI

public final class ReceiptViewCoordinator: ObservableObject {
    @Published
    private var destination: Destination

    private let addPositionViewModelFactory: () -> AddPositionViewModel
    private let editPositionViewModelFactory: () -> EditPositionViewModel

    public init(
        addPositionViewModelFactory: @escaping () -> AddPositionViewModel,
        editPositionViewModelFactory: @escaping () -> EditPositionViewModel
    ) {
        self.destination = .empty
        self.addPositionViewModelFactory = addPositionViewModelFactory
        self.editPositionViewModelFactory = editPositionViewModelFactory
    }

    @ViewBuilder
    public func destinationView() -> some View {
        switch destination {
        case .empty:
            EmptyView()
        case .addPosition:
            AddPositionView(addPositionViewModelFactory())
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
        case editPosition(positionId: UUID)
    }
}
