import SwiftUI

public struct SummaryPersonView: View {
    private let personName: String
    private let backgroundColor: Color

    public init(personName: String, backgroundColor: Color) {
        self.personName = personName
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Text(personName)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 8)
    }
}

struct SummaryPersonView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryPersonView(personName: "1st Person", backgroundColor: .green)
            .previewLayout(.sizeThatFits)
    }
}
