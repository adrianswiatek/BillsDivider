import SwiftUI

struct EditOverlayView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Price")) {
                    PriceSectionView(
                        priceText: $viewModel.priceText,
                        pricePlaceHolderText: viewModel.pricePlaceHolderText,
                        isPriceCorrect: viewModel.isPriceCorrect
                    )
                }

                Section {
                    BuyerSectionView(viewModel)
                    OwnerSectionView(viewModel)
                }

                Section {
                    Button(action: viewModel.confirmDidTap) {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                            Text("Confirm")
                            Spacer()
                        }
                    }
                    .disabled(!viewModel.canConfirm)
                    .accessibility(identifier: "EditOverlayView.confirmButton")
                }
            }
            .navigationBarTitle(Text(viewModel.pageName), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: viewModel.dismiss) {
                    Image(systemName: "xmark")
                        .frame(width: 32, height: 32)
                }
            )
        }
    }
}

struct EditOverlayView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView
    }
}
