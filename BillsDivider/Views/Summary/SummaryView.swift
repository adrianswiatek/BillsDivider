import BillsDivider_ViewModel
import Combine
import SwiftUI

public struct SummaryView: View {
    @ObservedObject private var viewModel: SummaryViewModel

    public init(_ viewModel: SummaryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            VStack {
                Separator()
                Spacer()
                peopleSummaryView
                Spacer()
                spentTotallyView
            }
            .navigationBarTitle("Summary")
        }
    }

    private var peopleSummaryView: some View {
        VStack {
            Spacer()

            SummaryPersonView(
                personName: viewModel.name(for: viewModel.buyerAtTheTop),
                backgroundColor: viewModel.color(for: viewModel.buyerAtTheTop)
            )
            .accessibility(identifier: "SummaryView.firstPersonText")

            Spacer()

            VStack {
                if viewModel.direction == .up {
                    Image(systemName: viewModel.formattedDirection)
                        .font(.largeTitle)
                        .offset(x: 0, y: -16)

                    Text(viewModel.formattedDebt)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                } else {
                    Text(viewModel.formattedDebt)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x: 0, y: -16)

                    Image(systemName: viewModel.formattedDirection)
                        .font(.largeTitle)
                }
            }
            .offset(x: 0, y: 16)

            Spacer()

            SummaryPersonView(
                personName: viewModel.name(for: viewModel.buyerAtTheBottom),
                backgroundColor: viewModel.color(for: viewModel.buyerAtTheBottom)
            )
            .accessibility(identifier: "SummaryView.secondPersonText")

            Spacer()
        }
        .padding(.horizontal)
    }

    private var spentTotallyView: some View {
        VStack {
            Separator()
            HStack {
                Text("Spent totally:")
                    .font(.system(size: 18))
                    .cornerRadius(8)
                    .padding(.horizontal, 32)

                Spacer()

                Text(viewModel.formattedSum)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .padding(.horizontal, 32)
            }
        }
        .padding(.bottom, 24)
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().summaryView
            .previewLayout(.sizeThatFits)
    }
}
