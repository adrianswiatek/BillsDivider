import Combine
import Foundation

struct AddingModeStrategy: EditOverlayStrategy {
    let receiptPosition: ReceiptPosition

    var pageName: String {
        "Add position"
    }

    var showAddAnother: Bool {
        true
    }

    private let positionAddedSubject: PassthroughSubject<ReceiptPosition, Never>

    init(receiptPosition: ReceiptPosition) {
        self.receiptPosition = receiptPosition
        self.positionAddedSubject = .init()
    }

    func set(viewModel: EditOverlayViewModel) {
        viewModel.priceText = ""
        viewModel.buyer = receiptPosition == .empty ? .me : receiptPosition.buyer
        viewModel.owner = receiptPosition == .empty ? .all : receiptPosition.owner
        viewModel.addAnother = true
        viewModel.positionAdded = positionAddedSubject.eraseToAnyPublisher()
    }

    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        positionAddedSubject.send(position)
    }
}
