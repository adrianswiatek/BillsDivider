import BillsDivider_Model
import BillsDivider_ViewModel
import SwiftUI

struct BuyerSectionView: View {
    @ObservedObject private var viewModel: BuyerViewModel

    init(_ viewModel: BuyerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            SectionLabel(withTitle: "Buyer")
            
            Picker(selection: $viewModel.buyer, label: EmptyView()) {
                ForEach(viewModel.buyers, id: \.self) {
                    Text($0.formatted).tag($0.formatted)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.trailing, 16)
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
