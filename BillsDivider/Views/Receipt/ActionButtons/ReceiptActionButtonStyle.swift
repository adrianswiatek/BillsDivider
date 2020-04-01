import SwiftUI

struct ReceiptActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .accentColor(.primary)
            .background(
                Circle()
                    .fill(Color("ActionButtonBackground"))
                    .shadow(
                        color: .secondary,
                        radius: 3,
                        x: configuration.isPressed ? -0.5 : 2,
                        y: configuration.isPressed ? -0.5 : 2
                    )
            )
            .transformEffect(.init(
                scaleX: configuration.isPressed ? 0.95 : 1,
                y: configuration.isPressed ? 0.95 : 1)
            )
    }
}
