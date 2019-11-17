import SwiftUI

struct PriceSectionView: View {
    @Binding var priceText: String

    var body: some View {
        HStack {
            TextField("0.00", text: $priceText)
                .multilineTextAlignment(.center)
                .font(.system(size: 42, weight: .medium, design: .rounded))
                .keyboardType(.decimalPad)
                .padding(.horizontal)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct PriceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PriceSectionView(priceText: .constant("2.99"))
    }
}
