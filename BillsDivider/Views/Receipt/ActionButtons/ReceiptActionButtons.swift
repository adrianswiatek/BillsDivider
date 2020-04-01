import SwiftUI

struct ReceiptActionButtons: View {
    @State private var presentingActionButtonMenu: Bool = false

    private let isEllipsisButtonEnabled: Bool

    private let onEllipsisButtonTapped: () -> Void
    private let onMinusButtonTapped: () -> Void
    private let onPlusButtonTapped: () -> Void

    init(
        isEllipsisButtonEnabled: Bool,
        onEllipsisButtonTapped: @escaping () -> Void,
        onMinusButtonTapped: @escaping () -> Void,
        onPlusButtonTapped: @escaping () -> Void
    ) {
        self.isEllipsisButtonEnabled = isEllipsisButtonEnabled
        self.onEllipsisButtonTapped = onEllipsisButtonTapped
        self.onMinusButtonTapped = onMinusButtonTapped
        self.onPlusButtonTapped = onPlusButtonTapped
    }

    var body: some View {
        ZStack {
            Group {
                minusButton
                plusSlashMinusButton
                plusButton
                ellipsisButton
            }
            .buttonStyle(ReceiptActionButtonStyle())
        }
        .padding(.trailing, 20)
        .accentColor(.primary)
        .animation(.spring())
        .onAppear { self.presentingActionButtonMenu = false }
    }

    private var minusButton: some View {
        Button(action: {
            self.presentingActionButtonMenu = false
            self.onEllipsisButtonTapped()
        }) {
            image(withName: "minus")
        }
        .offset(x: presentingActionButtonMenu ? -72 : 0, y: 0)
        .opacity(presentingActionButtonMenu
            ? isEllipsisButtonEnabled ? 1 : 0.5
            : 0
        )
        .disabled(!isEllipsisButtonEnabled)
    }

    private var plusSlashMinusButton: some View {
        Button(action: {
            self.presentingActionButtonMenu = false
            self.onMinusButtonTapped()
        }) {
            image(withName: "plus.slash.minus")
        }
        .offset(x: presentingActionButtonMenu ? -56 : 0, y: presentingActionButtonMenu ? -56 : 0)
        .opacity(presentingActionButtonMenu ? 1 : 0)
    }

    private var plusButton: some View {
        Button(action: {
            self.presentingActionButtonMenu = false
            self.onPlusButtonTapped()
        }) {
            image(withName: "plus")
        }
        .offset(x: 0, y: presentingActionButtonMenu ? -72 : 0)
        .opacity(presentingActionButtonMenu ? 1 : 0)
    }

    private var ellipsisButton: some View {
        Button(action: { self.presentingActionButtonMenu.toggle() }) {
            image(withName: "ellipsis")
                .rotationEffect(.degrees(90))
        }
        .offset(x: presentingActionButtonMenu ? 8 : 0, y: presentingActionButtonMenu ? 4 : 0)
    }

    private func image(withName name: String) -> some View {
        Image(systemName: name)
            .frame(width: 48, height: 48)
    }
}

struct ReceiptActionButtons_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptActionButtons(
            isEllipsisButtonEnabled: true,
            onEllipsisButtonTapped: {},
            onMinusButtonTapped: {},
            onPlusButtonTapped: {}
        )
    }
}
