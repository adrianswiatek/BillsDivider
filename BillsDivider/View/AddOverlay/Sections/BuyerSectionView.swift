import SwiftUI

struct BuyerSectionView: View {
    @Binding var buyer: Buyer

    var body: some View {
        HStack {
            Text("Buyer")
                .foregroundColor(Color(white: 0.6))
                .font(.footnote)

            Spacer()

            Picker(selection: $buyer, label: EmptyView()) {
                Text("Me").tag(Buyer.me)
                Text("Not me").tag(Buyer.notMe)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: UIScreen.main.bounds.width * 0.7)
        }
    }
}

struct BuyerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerSectionView(buyer: .constant(.me))
    }
}
