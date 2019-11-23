import SwiftUI

struct OwnerSectionView: View {
    @Binding var owner: Owner

    var body: some View {
        HStack {
            Text("Owner")
                .foregroundColor(Color(white: 0.6))
                .font(.footnote)

            Spacer()

            Picker(selection: $owner, label: EmptyView()) {
                Text("Me").tag(Owner.me)
                Text("Not me").tag(Owner.notMe)
                Text("All").tag(Owner.all)
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: UIScreen.main.bounds.width * 0.7)
        }
    }
}

struct OwnerSectionView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerSectionView(owner: .constant(.all))
    }
}
