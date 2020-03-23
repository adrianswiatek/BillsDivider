import SwiftUI

struct ReceiptHeaderView: View {
    var body: some View {
        HStack {
            Text("Value")
                .fontWeight(.bold)

            Spacer()

            Text("Buyer")
                .fontWeight(.bold)

            Text("|")
                .fontWeight(.light)

            Text("Owner")
                .fontWeight(.bold)
        }
        .font(.system(size: 14))
        .padding(.horizontal, 4)
    }
}

struct ReceiptHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptHeaderView
    }
}
