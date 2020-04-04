import BillsDivider_ViewModel
import SwiftUI

struct ReductionSectionView: View {
    @ObservedObject private var viewModel: PriceViewModel

    init(_ viewModel: PriceViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            SectionLabel(withTitle: "Reduction")

            HStack {
                Text(viewModel.validationMessage)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                TextField(viewModel.placeholder, text: $viewModel.text)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .padding(.horizontal)
                    .foregroundColor(viewModel.isValid ? .primary : .secondary)
                    .accessibility(identifier: "EditOverlayView.priceTextField")
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

struct AdditionalDiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().discountSectionView
    }
}
