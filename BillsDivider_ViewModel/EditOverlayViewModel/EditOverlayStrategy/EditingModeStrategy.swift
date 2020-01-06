import BillsDivider_Model
import Combine
import Foundation

public struct EditingModeStrategy: EditOverlayStrategy {
    public let receiptPosition: ReceiptPosition

    public var pageName: String {
        "Edit position"
    }

    private let numberFormatter: NumberFormatter
    private let positionEditedSubject: PassthroughSubject<ReceiptPosition, Never>

    public init(receiptPosition: ReceiptPosition, numberFormatter: NumberFormatter) {
        self.receiptPosition = receiptPosition
        self.numberFormatter = numberFormatter
        self.positionEditedSubject = .init()
    }

    public func set(viewModel: EditOverlayViewModel) {
        viewModel.priceText = numberFormatter.format(value: receiptPosition.amount)
        viewModel.addAnother = false
        viewModel.positionEdited = positionEditedSubject.eraseToAnyPublisher()

        viewModel.getInitialBuyer = { self.receiptPosition.buyer }
        viewModel.getInitialOwner = { self.receiptPosition.owner }
    }

    public func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {
        let position = ReceiptPosition(
            id: receiptPosition.id,
            amount: position.amount,
            buyer: position.buyer,
            owner: position.owner
        )
        positionEditedSubject.send(position)
    }
}
