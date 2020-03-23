import SwiftUI

struct SectionLabel: View {
    private let title: String

    init(withTitle title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .multilineTextAlignment(.leading)
            .foregroundColor(.secondary)
            .font(.system(size: 14))
            .padding(.leading, 12)
            .frame(width: 56)
    }
}

struct SectionLabel_Previews: PreviewProvider {
    static var previews: some View {
        SectionLabel(withTitle: "The Title")
    }
}
