import Combine
import Foundation

struct AddingModeStrategy2: EditOverlayStrategy2 {
    let receiptPosition: ReceiptPosition2

    var pageName: String {
        "Add position"
    }

    var showAddAnother: Bool {
        true
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition2, Never>

    init(receiptPosition: ReceiptPosition2) {
        self.receiptPosition = receiptPosition
        self.positionAddedSubject = .init()
    }

    func set(viewModel: EditOverlayViewModel2) {
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

    func confirmDidTap(with position: ReceiptPosition2, in viewModel: EditOverlayViewModel2) {
        positionAddedSubject.send(position)
    }
}
