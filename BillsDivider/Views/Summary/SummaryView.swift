import BillsDivider_ViewModel
import Combine
import SwiftUI

struct SummaryView: View {
    @ObservedObject private var viewModel: SummaryViewModel

    init(_ viewModel: SummaryViewModel) {
        self.viewModel = viewModel
    }

    var screenSize: CGRect {
        UIScreen.main.bounds
    }

    var body: some View {
        VStack {
            Text("Summary")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 24)
                .accessibility(identifier: "SummaryView.summaryText")

            Rectangle()
                .foregroundColor(.red)
                .frame(width: screenSize.width / 1.75, height: 0.7)
                .offset(x: 0, y: -16)

            Spacer()

            VStack {
                Text(viewModel.formattedDebt)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .offset(x: 0, y: 16)

                HStack {
                    generatePersonView(withLabel: viewModel.leftSidedBuyer.formatted, andColor: .green)
                        .accessibility(identifier: "SummaryView.firstPersonText")

                    Spacer()

                    Image(systemName: viewModel.formattedDirection)
                        .font(.largeTitle)

                    Spacer()

                    generatePersonView(withLabel: viewModel.rightSidedBuyer.formatted, andColor: .blue)
                        .accessibility(identifier: "SummaryView.secondPersonText")
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }

    private func generatePersonView(withLabel label: String, andColor color: Color) -> some View {
        Text(label)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .font(.system(size: 20))
            .foregroundColor(.white)
            .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(color)
            .cornerRadius(8)
            .frame(width: 120)
            .shadow(color: .gray, radius: 2, x: 0, y: 1)
            .padding(.horizontal, 8)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().summaryView
    }
}
