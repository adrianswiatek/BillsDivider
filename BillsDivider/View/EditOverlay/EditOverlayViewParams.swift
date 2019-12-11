struct EditOverlayViewParams {
    var show: Bool
    let mode: EditOverlayViewMode
    let position: ReceiptPosition

    private init(show: Bool, mode: EditOverlayViewMode, position: ReceiptPosition?) {
        self.show = show
        self.mode = mode
        self.position = position ?? .empty
    }

    static var hidden: EditOverlayViewParams {
        .init(show: false, mode: .adding, position: nil)
    }

    static func shown(mode: EditOverlayViewMode, position: ReceiptPosition?) -> EditOverlayViewParams {
        .init(show: true, mode: mode, position: position)
    }
}

enum EditOverlayViewMode {
    case adding, editing
}
