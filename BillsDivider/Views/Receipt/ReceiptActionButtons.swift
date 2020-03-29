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
            Button(action: {
                self.presentingActionButtonMenu = false
                self.onEllipsisButtonTapped()
            }) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
            .frame(width: 48, height: 48)
            .background(Circle().fill(Color("ActionButtonBackground")))
            .offset(x: presentingActionButtonMenu ? -64 : 0, y: 0)
            .opacity(presentingActionButtonMenu
                ? isEllipsisButtonEnabled ? 1 : 0.5
                : 0
            )
            .disabled(!isEllipsisButtonEnabled)

            Button(action: {
                self.presentingActionButtonMenu = false
                self.onMinusButtonTapped()
            }) {
                Image(systemName: "plus.slash.minus")
            }
            .frame(width: 48, height: 48)
            .background(Circle().fill(Color("ActionButtonBackground")))
            .offset(x: presentingActionButtonMenu ? -56 : 0, y: presentingActionButtonMenu ? -56 : 0)
            .opacity(presentingActionButtonMenu ? 1 : 0)

            Button(action: {
                self.presentingActionButtonMenu = false
                self.onPlusButtonTapped()
            }) {
                Image(systemName: "plus")
            }
            .frame(width: 48, height: 48)
            .background(Circle().fill(Color("ActionButtonBackground")))
            .offset(x: 0, y: presentingActionButtonMenu ? -64 : 0)
            .opacity(presentingActionButtonMenu ? 1 : 0)

            Button(action: { self.presentingActionButtonMenu.toggle() }) {
                Image(systemName: "triangle")
                    .rotationEffect(presentingActionButtonMenu ? .degrees(90) : .zero)
            }
            .frame(width: 48, height: 48)
            .background(Circle().fill(Color("ActionButtonBackground")))
            .scaleEffect(presentingActionButtonMenu ? 0.75 : 1)
        }
        .padding(.trailing, 20)
        .accentColor(.primary)
        .animation(.spring())
        .onAppear { self.presentingActionButtonMenu = false }
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
