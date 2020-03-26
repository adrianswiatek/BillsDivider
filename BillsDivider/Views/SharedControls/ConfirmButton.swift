import SwiftUI

struct ConfirmButton: View {
    private let canConfirm: Bool
    private let confirmDidTap: () -> Void

    init(canConfirm: Bool, confirmDidTap: @escaping () -> Void) {
        self.canConfirm = canConfirm
        self.confirmDidTap = confirmDidTap
    }

    var body: some View {
        Button(action: { self.confirmDidTap() }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Confirm")
            }
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(lineWidth: 1)
            )
            .background(Color("ControlsBackground"))
            .cornerRadius(10)
            .padding(.horizontal, 16)
        }
        .disabled(!canConfirm)
        .accessibility(identifier: "EditOverlayView.confirmButton")
    }
}

struct ConfirmButton_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmButton(canConfirm: true, confirmDidTap: {})
    }
}
