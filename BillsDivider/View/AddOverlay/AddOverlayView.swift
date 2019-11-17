import SwiftUI

struct AddOverlayView: View {
    @ObservedObject private var viewModel: AddOverlayViewModel

    init(_ presenting: Binding<Bool>) {
        self.viewModel = .init(presenting)
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Price")) {
                        PriceSectionView(priceText: $viewModel.priceText, isPriceCorrect: viewModel.isPriceCorrect)
                    }

                    Section(header: Text("Buyer")) {
                        BuyerSectionView(buyer: $viewModel.buyer)
                    }

                    Section(header: Text("Owner")) {
                        OwnerSectionView(owner: $viewModel.owner)
                    }

                    Section {
                        AddAnotherSectionView(addAnother: $viewModel.addAnother)
                    }

                    Section {
                        ConfirmSectionView(canConfirm: viewModel.canConfirm, onConfirm: viewModel.confirmDidTap)
                    }
                }
            }
            .navigationBarTitle(Text("Add position"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: viewModel.dismiss) {
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
            })
        }
    }
}

struct AddOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AddOverlayView(.constant(true))
    }
}
