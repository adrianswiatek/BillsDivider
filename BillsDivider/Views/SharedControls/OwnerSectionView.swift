import BillsDivider_ViewModel
import SwiftUI

struct OwnerSectionView: View {
    @ObservedObject var viewModel: OwnerViewModel

    init(_ viewModel: OwnerViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            SectionLabel(withTitle: "Owner")
            
            Picker(selection: $viewModel.owner, label: EmptyView()) {
                ForEach(viewModel.owners, id: \.self) {
                    Text($0.formatted).tag($0.formatted)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.trailing, 16)
            .background(Color("SettingsPeopleCellBackground"))
            .accessibility(identifier: "OwnerSectionView.segmentedControl")
        }
    }
}

struct OwnerSectionView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().ownerSectionView
    }
}
