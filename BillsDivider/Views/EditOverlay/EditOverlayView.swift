import BillsDivider_ViewModel
import SwiftUI

struct EditOverlayView: View {
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

            if viewModel.discountViewModel.presentingPopover {
                DiscountPopoverView(viewModel.discountPopoverViewModel)
            }
        }
    }

    private var controls: some View {
        VStack(alignment: .trailing) {
            PriceSectionView(viewModel.priceViewModel)
                .padding(.top, 16)

            DiscountSectionView(viewModel.discountViewModel)
            BuyerSectionView(viewModel.buyerViewModel)
            OwnerSectionView(viewModel.ownerViewModel)

            Separator()
                .padding(.trailing, 16)
                .padding(.vertical, 4)

            HStack {
                confirmValidationMessageText
                Spacer()
                confirmButton
            }

            Spacer()
        }
    }

    private var confirmValidationMessageText: some View {
        Text(viewModel.confirmValidationMessage)
            .foregroundColor(.red)
            .opacity(0.75)
            .font(.system(size: 13))
            .padding(.horizontal)
    }

    private var confirmButton: some View {
        ConfirmButton(canConfirm: viewModel.canConfirm, confirmDidTap: viewModel.confirmDidTap)
    }
}

struct EditOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView
    }
}
