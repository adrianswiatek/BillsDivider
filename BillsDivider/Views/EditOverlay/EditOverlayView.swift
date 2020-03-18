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

            DiscountPopoverView(viewModel.discountPopoverViewModel)
                .opacity(viewModel.discountViewModel.presentingPopover ? 1 : 0)
                .animation(.easeInOut(duration: 0.25))
        }
    }

    private var controls: some View {
        VStack(alignment: .trailing) {
            SectionLabel(withTitle: "Price")
                .padding(.top, 8)
            
            PriceSectionView(viewModel.priceViewModel)
                .border(Color.secondary, width: 0.5)

            DiscountSectionView(viewModel.discountViewModel)
            BuyerSectionView(viewModel)
            OwnerSectionView(viewModel)

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
        Button(action: { self.viewModel.confirmDidTap() }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Confirm")
            }
            .font(.system(size: 14))
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(lineWidth: 1)
            )
            .background(Color("ControlsBackground"))
            .cornerRadius(10)
            .padding(.horizontal, 16)
        }
        .disabled(!viewModel.canConfirm)
        .accessibility(identifier: "EditOverlayView.confirmButton")
    }
}

struct EditOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView
    }
}
