import Combine
import Foundation

struct EditingModeStrategy: EditOverlayStrategy {
    let receiptPosition: ReceiptPosition

    var pageName: String {
        "Edit position"
    }

    var showAddAnother: Bool {
        false
    }

    private let numberFormatter: NumberFormatter
    private let positionEditedSubject: PassthroughSubject<ReceiptPosition, Never>

    init(receiptPosition: ReceiptPosition, numberFormatter: NumberFormatter) {
        self.receiptPosition = receiptPosition
        self.numberFormatter = numberFormatter
        self.positionEditedSubject = .init()
    }

    func set(viewModel: EditOverlayViewModel) {
        viewModel.priceText = numberFormatter.format(value: receiptPosition.amount)
        viewModel.buyer = receiptPosition.buyer
        viewModel.owner = receiptPosition.owner
        viewModel.canConfirm = false
        viewModel.addAnother = false
        viewModel.positionEdited = positionEditedSubject.eraseToAnyPublisher()
    }

    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        let position = ReceiptPosition(
            id: receiptPosition.id,
            amount: position.amount,
            buyer: position.buyer,
            owner: position.owner
        )
        positionEditedSubject.send(position)
    }
}
