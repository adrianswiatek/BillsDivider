import SwiftUI

struct SummaryView: View {
    var screenSize: CGRect {
        UIScreen.main.bounds
    }

    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)

            Rectangle()
                .foregroundColor(.red)
                .frame(width: screenSize.width / 1.75, height: 0.7)
                .offset(x: 0, y: -16)

            Spacer()

            HStack {
                generatePersonView(withLabel: "Me", andColor: .blue)

                VStack {
                    Text("122,99")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: 0, y: 12)

                    Image(systemName: "arrow.right")
                        .font(.largeTitle)
                }
                .offset(x: 0, y: -32)

                generatePersonView(withLabel: "Not me", andColor: .green)
            }

            Spacer()
        }
    }

    private func generatePersonView(withLabel label: String, andColor color: Color) -> some View {
        Text(label)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(color)
            .cornerRadius(8)
            .frame(width: 100)
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 8)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
