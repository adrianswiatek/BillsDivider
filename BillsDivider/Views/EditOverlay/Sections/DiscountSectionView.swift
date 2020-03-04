import BillsDivider_ViewModel
import SwiftUI

struct DiscountSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Button(
                action: {
                    withAnimation { self.viewModel.showDiscount.toggle() }
                },
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                }
            )

            Text(viewModel.isDiscountCorrect ? "" : "Invalid discount")
                .font(.footnote)
                .foregroundColor(.secondary)

            ZStack {
                if !viewModel.discountText.isEmpty && viewModel.isDiscountCorrect {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .light, design: .rounded))
                        Text(viewModel.discountText.isEmpty ? viewModel.pricePlaceHolderText : viewModel.discountText)
                            .foregroundColor(.clear)
                    }
                }

                TextField(viewModel.pricePlaceHolderText, text: $viewModel.discountText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .foregroundColor(viewModel.isDiscountCorrect ? .primary : .secondary)
            }
            .font(.system(size: 28, weight: .medium, design: .rounded))
            .padding(.horizontal)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
//        DiscountSectionView(showDiscount: .constant(true))
    }
}
