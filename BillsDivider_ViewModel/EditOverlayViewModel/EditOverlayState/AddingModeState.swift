import BillsDivider_Model
import Combine
import Foundation

public struct AddingModeState: EditOverlayState {
    public let receiptPosition: ReceiptPosition

    public var pageName: String {
        "Add position"
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition, Never>

    public init(receiptPosition: ReceiptPosition) {
        self.receiptPosition = receiptPosition
        self.positionAddedSubject = .init()
    }

    public func set(viewModel: EditOverlayViewModel) {
        viewModel.priceViewModel.text = ""
        viewModel.addAnother = true
        viewModel.positionAdded = positionAddedSubject.eraseToAnyPublisher()

        viewModel.set(
            buyer: receiptPosition != .empty ? receiptPosition.buyer : viewModel.buyerViewModel.buyers[0],
            owner: receiptPosition != .empty ? receiptPosition.owner : .all
        )
    }

    public func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        positionAddedSubject.send(position)
    }
}
