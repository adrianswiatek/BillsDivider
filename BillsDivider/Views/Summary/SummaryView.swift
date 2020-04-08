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
        NavigationView {
            VStack {
                ScrollView {
                    Separator()

                    VStack {
                        Text(viewModel.formattedDebt)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .offset(x: 0, y: 16)

                        HStack {
                            generatePersonView(
                                withLabel: viewModel.name(for: viewModel.leftSidedBuyer),
                                andColor: viewModel.color(for: viewModel.leftSidedBuyer)
                            )
                                .accessibility(identifier: "SummaryView.firstPersonText")

                            Spacer()

                            Image(systemName: viewModel.formattedDirection)
                                .font(.largeTitle)

                            Spacer()

                            generatePersonView(
                                withLabel: viewModel.name(for: viewModel.rightSidedBuyer),
                                andColor: viewModel.color(for: viewModel.rightSidedBuyer)
                            )
                            .accessibility(identifier: "SummaryView.secondPersonText")
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height / 1.85)
                    .padding(.horizontal)
                }

                VStack {
                    Separator()

                    HStack {
                        Text("Spent totally:")
                            .font(.system(size: 18))
                            .padding(.leading, 32)

                        Spacer()

                        Text(viewModel.formattedSum)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding(.trailing, 32)
                    }
                }
                .padding(.vertical, 32)
            }
            .navigationBarTitle("Summary")
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
