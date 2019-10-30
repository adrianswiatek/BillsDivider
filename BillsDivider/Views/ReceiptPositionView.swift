import SwiftUI

struct ReceiptPositionView: View {
    private let position: ReceiptPosition
    private let columnWidth: CGFloat

    init(_ position: ReceiptPosition, _ columnWidth: CGFloat) {
        self.position = position
        self.columnWidth = columnWidth
    }

    var body: some View {
        HStack {
            Text("\(position.amount, specifier: "%.2f")")
                .frame(width: columnWidth)

            Text(position.buyer.formatted)
                .frame(width: columnWidth)

            Text(position.owner.formatted)
                .frame(width: columnWidth)
        }
    }
}

struct ReceiptPositionView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptPositionView(.empty, UIScreen.main.bounds.width / 3)
    }
}
