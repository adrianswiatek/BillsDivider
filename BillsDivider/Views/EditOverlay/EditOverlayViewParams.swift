import BillsDivider_Model

struct EditOverlayViewParams {
    var show: Bool
    let mode: EditOverlayViewMode

    private(set) var position: ReceiptPosition

    private init(show: Bool, mode: EditOverlayViewMode, position: ReceiptPosition?) {
        self.show = show
        self.mode = mode
        self.position = position ?? .empty
    }

    mutating func providePosition(_ position: ReceiptPosition?) {
        guard mode == .adding else { return }
        self.position = position ?? .empty
    }

    static var hidden: EditOverlayViewParams {
        .init(show: false, mode: .adding, position: nil)
    }

    static func shownAdding() -> EditOverlayViewParams {
        .init(show: true, mode: .adding, position: nil)
    }

    static func shownEditing(_ position: ReceiptPosition) -> EditOverlayViewParams {
        .init(show: true, mode: .editing, position: position)
    }
}

enum EditOverlayViewMode {
    case adding, editing
}
