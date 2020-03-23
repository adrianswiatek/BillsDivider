import BillsDivider_ViewModel
import SwiftUI

struct DiscountSectionView: View {
    @ObservedObject private var viewModel: DiscountViewModel

    init(_ viewModel: DiscountViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if viewModel.hasDiscount {
                discountSection
            } else {
                addDiscountButton
            }
        }
        .animation(.easeInOut)
    }

    private var discountSection: some View {
        HStack {
            SectionLabel(withTitle: "Disc.")

            HStack {
                Button(action: { self.viewModel.removeDiscount() }) {
                    Image(systemName: "xmark.circle.fill")
                }
                .padding(.horizontal)

                Spacer()
                Text("- \(viewModel.text)")
                    .font(.system(size: 32))
                    .bold()
                    .opacity(0.65)
                    .padding(.trailing)
            }
            .padding(.trailing)
        }
    }

    private var addDiscountButton: some View {
        Button(action: { self.viewModel.showDiscountPopover() }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add discount")
            }
            .font(.system(size: 14))
            .padding(.trailing, 24)
            .padding(.vertical, 12)
        }
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().discountSectionView
    }
}
