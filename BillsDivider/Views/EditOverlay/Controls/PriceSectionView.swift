import BillsDivider_ViewModel
import SwiftUI

struct PriceSectionView: View {
    @ObservedObject private var viewModel: PriceViewModel
    private let priceTextFieldFactory: PriceTextFieldFactory

    init(_ viewModel: PriceViewModel, _ priceTextFieldFactory: PriceTextFieldFactory) {
        self.viewModel = viewModel
        self.priceTextFieldFactory = priceTextFieldFactory
    }

    var body: some View {
        HStack {
            SectionLabel(withTitle: "Price")

            HStack {
                Text(viewModel.validationMessage)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                priceTextFieldFactory
                    .create(text: $viewModel.text, accessilibityIdentifier: "EditOverlayView.priceTextField")
                    .padding(.horizontal)
            }
            .padding(.vertical, 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.secondary)
            )
            .background(Color("ControlsBackground"))
            .cornerRadius(10)
            .padding(.trailing, 16)
        }
    }
}

struct PriceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().priceSectionView
    }
}
