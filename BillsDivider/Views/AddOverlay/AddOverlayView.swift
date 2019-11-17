import SwiftUI

struct AddOverlayView: View {
    @Binding var presenting: Bool

    @State private var priceText: String = ""
    @State private var buyer: Buyer = .me
    @State private var owner: Owner = .all
    @State private var addAnother: Bool = true

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Price")) {
                        PriceSectionView(priceText: $priceText)
                    }

                    Section(header: Text("Buyer")) {
                        BuyerSectionView(buyer: $buyer)
                    }

                    Section(header: Text("Owner")) {
                        OwnerSectionView(owner: $owner)
                    }

                    Section {
                        AddAnotherSectionView(addAnother: $addAnother)
                    }

                    Section {
                        ConfirmSectionView(priceText: $priceText) {
                            self.priceText.removeAll()
                            self.presenting = self.addAnother
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Add position"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.presenting = false }) {
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
            })
        }
    }
}

struct AddOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        AddOverlayView(presenting: .constant(true))
    }
}
