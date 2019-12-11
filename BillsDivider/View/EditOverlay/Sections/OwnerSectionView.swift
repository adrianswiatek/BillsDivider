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
                Text(Owner.me.formatted).tag(Owner.me)
                Text(Owner.notMe.formatted).tag(Owner.notMe)
                Text(Owner.all.formatted).tag(Owner.all)
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
