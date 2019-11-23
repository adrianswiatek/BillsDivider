import SwiftUI

struct PriceSectionView: View {
    @Binding private var priceText: String

    private var pricePlaceHolderText: String
    private var isPriceCorrect: Bool

    init(priceText: Binding<String>, pricePlaceHolderText: String, isPriceCorrect: Bool) {
        self._priceText = priceText
        self.pricePlaceHolderText = pricePlaceHolderText
        self.isPriceCorrect = isPriceCorrect
    }

    var body: some View {
        HStack {
            Text(isPriceCorrect ? "" : "Invalid price")
                .font(.footnote)
                .foregroundColor(.secondary)

            TextField(pricePlaceHolderText, text: $priceText)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 42, weight: .medium, design: .rounded))
                .keyboardType(.decimalPad)
                .padding(.horizontal)
                .foregroundColor(isPriceCorrect ? .primary : .secondary)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct PriceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PriceSectionView(priceText: .constant(""), pricePlaceHolderText: "0.00", isPriceCorrect: true)
    }
}
