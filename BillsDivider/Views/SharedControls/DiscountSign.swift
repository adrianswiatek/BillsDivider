import SwiftUI

struct DiscountSign: View {
    var body: some View {
        Text("%")
            .foregroundColor(.red)
            .fontWeight(.light)
            .padding(3)
            .overlay(overlay)
    }

    private var overlay: some View {
        Circle()
            .stroke(lineWidth: 0.75)
            .foregroundColor(.red)
    }
}

struct DiscountSign_Previews: PreviewProvider {
    static var previews: some View {
        DiscountSign()
    }
}
