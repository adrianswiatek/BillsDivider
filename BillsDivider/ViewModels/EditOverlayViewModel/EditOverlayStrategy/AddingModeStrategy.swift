import BillsDivider_Model
import Combine
import Foundation

struct AddingModeStrategy: EditOverlayStrategy {
    let receiptPosition: ReceiptPosition

    var pageName: String {
        "Add position"
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition, Never>

    init(receiptPosition: ReceiptPosition) {
        self.receiptPosition = receiptPosition
        self.positionAddedSubject = .init()
    }

    func set(viewModel: EditOverlayViewModel) {
        viewModel.priceText = ""
        viewModel.addAnother = true
        viewModel.positionAdded = positionAddedSubject.eraseToAnyPublisher()

        viewModel.getInitialBuyer = {
            self.receiptPosition != .empty ? self.receiptPosition.buyer : viewModel.buyers[0]
        }

        viewModel.getInitialOwner = {
            self.receiptPosition != .empty ? self.receiptPosition.owner : .all
        }
    }

    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        positionAddedSubject.send(position)
    }
}
