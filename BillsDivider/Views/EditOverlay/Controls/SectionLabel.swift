import SwiftUI

struct SectionLabel: View {
    private let title: String

    init(withTitle title: String) {
        self.title = title
    }

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 2)

            Spacer()
        }
        .padding(.bottom, -8)
    }
}

struct SectionLabel_Previews: PreviewProvider {
    static var previews: some View {
        SectionLabel(withTitle: "The Title")
    }
}
