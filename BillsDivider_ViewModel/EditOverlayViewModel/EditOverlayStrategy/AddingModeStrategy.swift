import BillsDivider_Model
import Combine
import Foundation

public struct AddingModeStrategy: EditOverlayStrategy {
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

        viewModel.getInitialBuyer = {
            self.receiptPosition != .empty ? self.receiptPosition.buyer : viewModel.buyers[0]
        }

        viewModel.getInitialOwner = {
            self.receiptPosition != .empty ? self.receiptPosition.owner : .all
        }
    }

    public func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        positionAddedSubject.send(position)
    }
}
