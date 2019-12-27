import SwiftUI

struct EditOverlayView2: View {
    @ObservedObject private var viewModel: EditOverlayViewModel2

    init(_ viewModel: EditOverlayViewModel2) {
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
                    BuyerSectionView2(viewModel)
                    OwnerSectionView2(viewModel)
                }

                if viewModel.showAddAnother {
                    Section {
                        AddAnotherSectionView(addAnother: $viewModel.addAnother)
                    }
                }
            }
            .navigationBarTitle(Text(viewModel.pageName), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: viewModel.dismiss) {
                    Image(systemName: "xmark")
                        .frame(width: 32, height: 32)
                },
                trailing: Button(action: viewModel.confirmDidTap) {
                    Image(systemName: "checkmark.circle.fill")
                        .frame(width: 32, height: 32)
                }
                .disabled(!viewModel.canConfirm)
            )
        }
    }
}

struct EditOverlayView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView2
    }
}
