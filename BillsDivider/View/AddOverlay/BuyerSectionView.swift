import SwiftUI

struct BuyerSectionView: View {
    @Binding var buyer: Buyer

    var body: some View {
        Picker(selection: $buyer, label: Text("Buyer")) {
            Text("Me").tag(Buyer.me)
            Text("Not me").tag(Buyer.notMe)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct BuyerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerSectionView(buyer: .constant(.me))
    }
}
