import SwiftUI

struct Separator: View {
    var body: some View {
        Color("Separator")
            .frame(width: UIScreen.main.bounds.width - 32, height: 0.5)
    }
}

struct Separator_Previews: PreviewProvider {
    static var previews: some View {
        Separator()
    }
}
