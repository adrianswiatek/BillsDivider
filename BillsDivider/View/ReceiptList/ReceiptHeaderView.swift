import SwiftUI

struct ReceiptHeaderView: View {
    private let columnWidth: CGFloat

    init(_ columnWidth: CGFloat) {
        self.columnWidth = columnWidth
    }

    var body: some View {
        HStack {
            Text("Amount")
                .fontWeight(.bold)
                .frame(width: columnWidth)

            Text("Buyer")
                .fontWeight(.bold)
                .frame(width: columnWidth)

            Text("Owner")
                .fontWeight(.bold)
                .frame(width: columnWidth)
        }
    }
}

struct ReceiptHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptHeaderView
    }
}
