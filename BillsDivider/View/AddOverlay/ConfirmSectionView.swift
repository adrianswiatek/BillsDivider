import SwiftUI

struct ConfirmSectionView: View {
    private let canConfirm: Bool
    private let onConfirm: () -> Void

    init(canConfirm: Bool, onConfirm: @escaping () -> Void) {
        self.canConfirm = canConfirm
        self.onConfirm = onConfirm
    }

    var body: some View {
        Button(action: onConfirm) {
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                Text("CONFIRM")
                Spacer()
            }
        }
        .disabled(!canConfirm)
    }
}

struct ConfirmSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmSectionView(canConfirm: true) { }
    }
}
