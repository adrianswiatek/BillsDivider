@testable import BillsDivider_Model
@testable import BillsDivider_ViewModel

class EditOverlayStrategyDummy: EditOverlayStrategy {
    let receiptPosition: ReceiptPosition = .empty
    let pageName: String = ""
    let showAddAnother: Bool = false

    func set(viewModel: EditOverlayViewModel) {}
    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel) {}
}
