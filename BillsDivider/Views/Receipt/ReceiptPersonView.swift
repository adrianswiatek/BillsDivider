import SwiftUI

struct ReceiptPersonView: View {
    private let name: String
    private let color: Color

    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }

    var body: some View {
        Text(name)
            .padding(.init(top: 1, leading: 8, bottom: 2, trailing: 8))
            .background(
                Capsule(style: .continuous)
                    .foregroundColor(color)
            )
            .lineLimit(1)
            .foregroundColor(.white)
    }
}

struct ReceiptPersonView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptPersonView(name: "Test Name", color: .blue)
    }
}