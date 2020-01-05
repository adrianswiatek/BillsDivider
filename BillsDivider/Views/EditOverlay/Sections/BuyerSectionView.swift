import SwiftUI

struct BuyerSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text("Buyer")
                .foregroundColor(Color(white: 0.6))
                .font(.footnote)

            Spacer()

            Picker(selection: $viewModel.buyer, label: EmptyView()) {
                ForEach(viewModel.buyers, id: \.self) {
                    Text($0.formatted).tag($0.formatted)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: UIScreen.main.bounds.width * 0.7)
            .accessibility(identifier: "BuyerSectionView.segmentedControl")
        }
    }
}

struct BuyerSectionView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().buyerSectionView
    }
}
