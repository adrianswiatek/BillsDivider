import SwiftUI

struct ReceiptPositionView: View {
    private let position: ReceiptPosition
    private let columnWidth: CGFloat
    private let formatNumber: (Decimal) -> String

    init(
        _ position: ReceiptPosition,
        _ columnWidth: CGFloat,
        _ formatNumber: @escaping (Decimal) -> String
    ) {
        self.position = position
        self.columnWidth = columnWidth
        self.formatNumber = formatNumber
    }

    var body: some View {
        HStack {
            HStack {
                Text(formatNumber(position.amount))
            }
            .frame(width: columnWidth)

            HStack {
                Text(position.buyer.formatted)
                    .foregroundColor(.white)
                    .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                    .background(
                        Capsule(style: .continuous)
                            .foregroundColor(getBuyerColor())
                    )
            }
            .frame(width: columnWidth)

            HStack {
                Text(position.owner.formatted)
                    .foregroundColor(.white)
                    .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
                    .background(
                        Capsule(style: .continuous)
                            .foregroundColor(getOwnerColor())
                    )
            }
            .frame(width: columnWidth)
        }
    }

    private func getBuyerColor() -> Color {
        switch position.buyer {
        case .me: return .blue
        case .notMe: return .green
        }
    }

    private func getOwnerColor() -> Color {
        switch position.owner {
        case .me: return .blue
        case .notMe: return .green
        case .all: return .purple
        }
    }
}

struct ReceiptPositionView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptPositionView(
            .empty,
            UIScreen.main.bounds.width / 3,
            NumberFormatter.twoFracionDigitsNumberFormatter.format
        )
    }
}
