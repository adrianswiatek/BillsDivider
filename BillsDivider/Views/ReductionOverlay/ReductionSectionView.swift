import BillsDivider_ViewModel
import SwiftUI

struct ReductionSectionView: View {
    @ObservedObject private var viewModel: PriceViewModel
    private let priceTextFieldFactory: PriceTextFieldFactory

    init(_ viewModel: PriceViewModel, _ priceTextFieldFactory: PriceTextFieldFactory) {
        self.viewModel = viewModel
        self.priceTextFieldFactory = priceTextFieldFactory
    }

    var body: some View {
        HStack {
            Text(viewModel.validationMessage)
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            ZStack {
                if !viewModel.text.isEmpty && viewModel.isValid {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 42, weight: .light, design: .rounded))
                        Text(viewModel.text.isEmpty ? viewModel.placeholder : viewModel.text)
                            .foregroundColor(.clear)
                    }
                }

                priceTextFieldFactory
                    .create(text: $viewModel.text, accessilibityIdentifier: "EditOverlayView.priceTextField")
            }
            .font(.system(size: 42, weight: .bold, design: .rounded))
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
        .padding(.horizontal, 16)
    }
}

struct ReductionSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().reductionSectionView
    }
}
