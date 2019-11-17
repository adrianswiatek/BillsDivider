import SwiftUI

struct OwnerSectionView: View {
    @Binding var owner: Owner

    var body: some View {
        Picker(selection: $owner, label: Text("Buyer")) {
            Text("Me").tag(Owner.me)
            Text("Not me").tag(Owner.notMe)
            Text("All").tag(Owner.all)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct OwnerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerSectionView(owner: .constant(.all))
    }
}
