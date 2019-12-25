struct EditOverlayViewParams2 {
    var show: Bool
    let mode: EditOverlayViewMode

    private(set) var position: ReceiptPosition2

    private init(show: Bool, mode: EditOverlayViewMode, position: ReceiptPosition2?) {
        self.show = show
        self.mode = mode
        self.position = position ?? .empty
    }

    mutating func providePosition(_ position: ReceiptPosition2?) {
        guard mode == .adding else { return }
        self.position = position ?? .empty
    }

    static var hidden: EditOverlayViewParams2 {
        .init(show: false, mode: .adding, position: nil)
    }

    static func shownAdding() -> EditOverlayViewParams2 {
        .init(show: true, mode: .adding, position: nil)
    }

    static func shownEditing(_ position: ReceiptPosition2) -> EditOverlayViewParams2 {
        .init(show: true, mode: .editing, position: position)
    }
}

enum EditOverlayViewMode {
    case adding, editing
}
