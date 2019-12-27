import Combine

protocol EditOverlayStrategy2 {
    var receiptPosition: ReceiptPosition2 { get }
    var pageName: String { get }
    var showAddAnother: Bool { get }

    func set(viewModel: EditOverlayViewModel2)
    func confirmDidTap(with position: ReceiptPosition2, in viewModel: EditOverlayViewModel2)
}
