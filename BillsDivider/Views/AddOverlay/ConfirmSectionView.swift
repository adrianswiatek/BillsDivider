import SwiftUI

struct ConfirmSectionView: View {
    @Binding private var priceText: String
    private let onTap: () -> Void

    init(priceText: Binding<String>, _ onTap: @escaping () -> Void) {
        self._priceText = priceText
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                Text("CONFIRM")
                Spacer()
            }
        }
        .disabled(priceText.isEmpty)
    }
}

struct ConfirmSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSectionView(priceText: .constant("0.99")) { }
    }
}
