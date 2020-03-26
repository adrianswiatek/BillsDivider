import BillsDivider_ViewModel
import SwiftUI

struct ReductionOverlayView: View {
    @ObservedObject private var viewModel: ReductionOverlayViewModel

    init(_ viewModel: ReductionOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .trailing) {
                        ReductionSectionView(viewModel.priceViewModel)
                            .padding(.top, 16)

                        BuyerSectionView(viewModel.buyerViewModel)
                        OwnerSectionView(viewModel.ownerViewModel)

                        Separator()
                            .padding(.trailing, 16)
                            .padding(.vertical, 4)

                        HStack {
                            Spacer()
                            ConfirmButton(canConfirm: viewModel.canConfirm, confirmDidTap: viewModel.confirmDidTap)
                        }

                        Spacer()
                    }
                    .navigationBarTitle(Text("Add reduction"), displayMode: .inline)
                    .navigationBarItems(
                        trailing: Button(action: viewModel.dismiss) {
                            Image(systemName: "xmark")
                                .frame(width: 32, height: 32)
                        }
                    )
                }
                .background(Color("SettingsPeopleCellBackground"))
            }
        }
    }
}

struct ReductionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().editOverlayView
    }
}
