import BillsDivider_ViewModel
import SwiftUI

struct PriceSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.isPriceCorrect ? "" : "Invalid price")
                .font(.footnote)
                .foregroundColor(.secondary)

            TextField(viewModel.pricePlaceHolderText, text: $viewModel.priceText)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 42, weight: .medium, design: .rounded))
                .keyboardType(.decimalPad)
                .padding(.horizontal)
                .foregroundColor(viewModel.isPriceCorrect ? .primary : .secondary)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct PriceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
