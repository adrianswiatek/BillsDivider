import BillsDivider_ViewModel
import SwiftUI

struct EditOverlayView2: View {
    @ObservedObject private var viewModel: EditOverlayViewModel

    init(_ viewModel: EditOverlayViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView{
            ScrollView {
                VStack(alignment: .trailing) {
                    sectionLabel(withTitle: "Price")

                    PriceSectionView(viewModel: viewModel.price)
                        .border(Color.secondary, width: 0.5)
                        .background(Color("ControlsBackground"))

                    Button(action: {}) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add discount")
                        }
                        .font(.system(size: 14))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    }

                    sectionLabel(withTitle: "Buyer")

                    BuyerSectionView(viewModel)
                        .background(Color("ControlsBackground"))

                    sectionLabel(withTitle: "Owner")

                    OwnerSectionView(viewModel)
                        .background(Color("ControlsBackground"))

                    Separator()
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)

                    confirmButton

                    Spacer()
                }
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
    }

    private func sectionLabel(withTitle title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
                .font(.system(size: 14))
                .padding(.horizontal, 12)
                .padding(.top, 4)
                .padding(.bottom, 2)

            Spacer()
        }
        .padding(.bottom, -12)
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
