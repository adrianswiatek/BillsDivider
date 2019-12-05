import SwiftUI

struct AddOverlayView: View {
    @ObservedObject private var viewModel: AddOverlayViewModel

    init(_ viewModel: AddOverlayViewModel) {
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
                    BuyerSectionView(buyer: $viewModel.buyer)
                    OwnerSectionView(owner: $viewModel.owner)
                }

                Section {
                    AddAnotherSectionView(addAnother: $viewModel.addAnother)
                }
            }
            .navigationBarTitle(Text("Add position"), displayMode: .inline)
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

struct AddOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModelFactory: ViewModelFactory = .default
        return AddOverlayView(viewModelFactory.addOverlayViewModel(presenting: .constant(true)))
    }
}
