import Combine

protocol EditOverlayStrategy {
    var receiptPosition: ReceiptPosition { get }
    var pageName: String { get }
    var showAddAnother: Bool { get }

    func set(viewModel: EditOverlayViewModel)
    func confirmDidTap(with position: ReceiptPosition, in viewModel: EditOverlayViewModel)
}
