import SwiftUI

struct AddAnotherSectionView: View {
    @Binding var addAnother: Bool

    var body: some View {
        Toggle("Add another", isOn: $addAnother)
            .foregroundColor(Color(white: 0.4))
            .font(.footnote)
    }
}

struct AddAnotherSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddAnotherSectionView(addAnother: .constant(true))
    }
}
