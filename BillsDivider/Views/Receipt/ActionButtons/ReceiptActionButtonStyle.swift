import SwiftUI

struct ReceiptActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .accentColor(.primary)
            .background(
                Circle()
                    .fill(Color("ActionButtonBackground"))
                    .shadow(
                        color: Color("ActionButtonShadow"),
                        radius: configuration.isPressed ? 2 : 3,
                        x: configuration.isPressed ? 1 : 2,
                        y: configuration.isPressed ? 1 : 2
                    )
                    .animation(.none)
            )
            .transformEffect(.init(
                scaleX: configuration.isPressed ? 0.95 : 1,
                y: configuration.isPressed ? 0.95 : 1)
            )
    }
}
