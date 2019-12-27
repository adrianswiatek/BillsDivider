import Combine
import Foundation

struct EditingModeStrategy2: EditOverlayStrategy2 {
    let receiptPosition: ReceiptPosition2

    var pageName: String {
        "Edit position"
    }

    var showAddAnother: Bool {
        false
    }

    private let numberFormatter: NumberFormatter
    private let positionEditedSubject: PassthroughSubject<ReceiptPosition2, Never>

    init(receiptPosition: ReceiptPosition2, numberFormatter: NumberFormatter) {
        self.receiptPosition = receiptPosition
        self.numberFormatter = numberFormatter
        self.positionEditedSubject = .init()
    }

    func set(viewModel: EditOverlayViewModel2) {
        viewModel.priceText = numberFormatter.format(value: receiptPosition.amount)
        viewModel.addAnother = false
        viewModel.positionEdited = positionEditedSubject.eraseToAnyPublisher()

        viewModel.getInitialBuyer = { self.receiptPosition.buyer }
        viewModel.getInitialOwner = { self.receiptPosition.owner }
    }

    func confirmDidTap(with position: ReceiptPosition2, in viewModel: EditOverlayViewModel2) {
        let position = ReceiptPosition2(
            id: receiptPosition.id,
            amount: position.amount,
            buyer: position.buyer,
            owner: position.owner
        )
        positionEditedSubject.send(position)
    }
}
