import BillsDivider_ViewModel
import SwiftUI

struct DiscountSectionView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.hasDiscount {
                SectionLabel(withTitle: "Discount")
                
                HStack {
                    Spacer()
                    Text(viewModel.discount)
                        .font(.system(size: 32))
                        .bold()
                        .padding(.horizontal)
                }
            } else {
                Button(action: { self.viewModel.discountButtonDidTap() }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add discount")
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
