import BillsDivider_Model

struct EditOverlayViewParams {
    let mode: EditOverlayViewMode

    private(set) var position: ReceiptPosition

    private init(mode: EditOverlayViewMode, position: ReceiptPosition?) {
        self.mode = mode
        self.position = position ?? .empty
    }

    mutating func providePosition(_ position: ReceiptPosition?) {
        guard mode == .adding else { return }
        self.position = position ?? .empty
    }

    static var adding: EditOverlayViewParams {
        .init(mode: .adding, position: nil)
    }

    static func editing(withPosition position: ReceiptPosition) -> EditOverlayViewParams {
        .init(mode: .editing, position: position)
    }
}

enum EditOverlayViewMode {
    case adding, editing
}
