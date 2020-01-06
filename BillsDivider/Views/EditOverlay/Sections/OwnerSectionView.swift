import BillsDivider_ViewModel
import SwiftUI

struct OwnerSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text("Owner")
                .foregroundColor(Color(white: 0.6))
                .font(.footnote)

            Spacer()

            Picker(selection: $viewModel.owner, label: EmptyView()) {
                ForEach(viewModel.owners, id: \.self) {
                    Text($0.formatted).tag($0.formatted)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: UIScreen.main.bounds.width * 0.7)
            .accessibility(identifier: "OwnerSectionView.segmentedControl")
        }
    }
}

struct OwnerSectionView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().ownerSectionView
    }
}
