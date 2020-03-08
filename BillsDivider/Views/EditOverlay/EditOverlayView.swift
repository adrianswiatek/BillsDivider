import BillsDivider_ViewModel
import SwiftUI

struct EditOverlayView: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        PriceSectionView(viewModel: viewModel.price)

                        if viewModel.showDiscount {
                            DiscountSectionView(
                                viewModel: viewModel.discount,
                                hideDiscount: { self.viewModel.showDiscount.toggle() }
                            )
                        } else {
                            HStack {
                                Button(action: { withAnimation { self.viewModel.showDiscount = true } }) {
                                    HStack {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Add discount")
                                    }
                                    .font(.system(size: 14))
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }

                    Section {
                        BuyerSectionView(viewModel)
                        OwnerSectionView(viewModel)
                    }

                    Section {
                        Button(action: viewModel.confirmDidTap) {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                Text("Confirm")
                                Spacer()
                            }
                        }
                        .disabled(!viewModel.canConfirm)
                        .accessibility(identifier: "EditOverlayView.confirmButton")
                    }
                }

                Rectangle()
                    .foregroundColor(Color.clear)
                    .background(Color.clear)
                    .frame(height: viewModel.keyboardHeight)
            }
            .navigationBarTitle(Text(viewModel.pageName), displayMode: .inline)
            .navigationBarItems(
                trailing: Button(action: viewModel.dismiss) {
                    Image(systemName: "xmark")
                        .frame(width: 32, height: 32)
                }
            )
        }
    }
}

struct EditOverlayView2_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView
    }
}
