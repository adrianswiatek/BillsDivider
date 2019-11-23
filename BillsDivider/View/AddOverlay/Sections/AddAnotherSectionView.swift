import SwiftUI

struct AddAnotherSectionView: View {
    @Binding private var addAnother: Bool

    init(addAnother: Binding<Bool>) {
        self._addAnother = addAnother
    }

    var body: some View {
        HStack {
            Text("Add another")
                .frame(width: 100)
                .foregroundColor(Color(white: 0.6))
                .font(.footnote)
            Toggle("", isOn: $addAnother)
        }
    }
}

struct AddAnotherSectionView_Previews: PreviewProvider {
    static var previews: some View {
        AddAnotherSectionView(addAnother: .constant(true))
    }
}
