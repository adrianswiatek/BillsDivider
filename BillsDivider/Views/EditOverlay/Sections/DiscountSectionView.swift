import SwiftUI

struct DiscountSectionView: View {
    @Binding private var showDiscount: Bool
    @State private var discountText: String = ""
    private let isPriceCorrect: Bool = true
    private let discountPlaceHolderText: String = "0.00"

    init(showDiscount: Binding<Bool>) {
        self._showDiscount = showDiscount
    }

    var body: some View {
        HStack {
            Button(
                action: {
                    withAnimation { self.showDiscount = false }
                },
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                }
            )

            Text(isPriceCorrect ? "" : "Invalid discount")
                .font(.footnote)
                .foregroundColor(.secondary)

            ZStack {
                if !discountText.isEmpty && isPriceCorrect {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .light, design: .rounded))
                        Text(discountText.isEmpty ? discountPlaceHolderText : discountText)
                            .foregroundColor(.clear)
                    }
                }

                TextField(discountPlaceHolderText, text: $discountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .foregroundColor(isPriceCorrect ? .primary : .secondary)
            }
            .font(.system(size: 28, weight: .medium, design: .rounded))
            .padding(.horizontal)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        DiscountSectionView(showDiscount: .constant(true))
    }
}
