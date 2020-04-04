import BillsDivider_Model

struct EditOverlayViewParams {
    let mode: EditOverlayViewMode
    let position: ReceiptPosition

    private init(mode: EditOverlayViewMode, position: ReceiptPosition?) {
        self.mode = mode
        self.position = position ?? .empty
    }

    func withProvidedPosition(_ position: ReceiptPosition?) -> EditOverlayViewParams {
        guard mode == .adding else { return self }
        return .init(mode: .adding, position: position ?? .empty)
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
