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
        viewModel.addAnother = false
        viewModel.positionEdited = positionEditedSubject.eraseToAnyPublisher()

        viewModel.getInitialBuyer = { self.receiptPosition.buyer }
        viewModel.getInitialOwner = { self.receiptPosition.owner }
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
