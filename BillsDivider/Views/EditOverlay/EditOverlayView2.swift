import BillsDivider_ViewModel
import SwiftUI

struct EditOverlayView2: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    controls
                    .navigationBarTitle(Text(viewModel.pageName), displayMode: .inline)
                    .navigationBarItems(
                        trailing: Button(action: viewModel.dismiss) {
                            Image(systemName: "xmark")
                                .frame(width: 32, height: 32)
                        }
                    )
                }
                .background(Color("SettingsPeopleCellBackground"))
            }

            DiscountPopover(viewModel: viewModel.discount)
                .opacity(viewModel.presentingDiscountPopover ? 1 : 0)
                .animation(.easeInOut(duration: 0.25))
        }
    }

    private var controls: some View {
        VStack(alignment: .trailing) {
            SectionLabel(withTitle: "Price")
            PriceSectionView(viewModel: viewModel.price)
                .border(Color.secondary, width: 0.5)

            addDiscountButton

            SectionLabel(withTitle: "Buyer")
            BuyerSectionView(viewModel)

            SectionLabel(withTitle: "Owner")
            OwnerSectionView(viewModel)

            Separator()
                .padding(.trailing, 16)
                .padding(.vertical, 4)

            confirmButton

            Spacer()
        }
    }

    private var addDiscountButton: some View {
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

    private var confirmButton: some View {
        Button(action: { self.viewModel.confirmDidTap() }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Confirm")
            }
            .font(.system(size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .circular)
                    .stroke(lineWidth: 0.75)
            )
            .background(Color("ControlsBackground"))
            .cornerRadius(8)
            .padding(.horizontal, 16)
        }
        .disabled(!viewModel.canConfirm)
        .accessibility(identifier: "EditOverlayView.confirmButton")
    }
}

struct EditOverlayView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView2
    }
}
