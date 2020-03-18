import BillsDivider_ViewModel
import SwiftUI

struct BuyerSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            SectionLabel(withTitle: "Buyer")
            
            Picker(selection: $viewModel.buyer, label: EmptyView()) {
                ForEach(viewModel.buyers, id: \.self) {
                    Text($0.formatted).tag($0.formatted)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(Color("SettingsPeopleCellBackground"))
            .accessibility(identifier: "BuyerSectionView.segmentedControl")
        }
    }
}

struct BuyerSectionView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().buyerSectionView
    }
}
