import BillsDivider_Model
import Combine

public protocol EditOverlayState {
    var receiptPosition: ReceiptPosition { get }
    var pageName: String { get }

    func set(viewModel: EditOverlayViewModel)
    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel)
}
