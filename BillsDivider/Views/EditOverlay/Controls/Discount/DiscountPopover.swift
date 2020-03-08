import BillsDivider_ViewModel
import SwiftUI

struct DiscountPopover: View {
    private let viewModel: EditOverlayDiscountViewModel

    init(viewModel: EditOverlayDiscountViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.vertical)

            VStack {
                HStack {
                    Text("%")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .bold()

                    Text("Discount")
                        .bold()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("SettingsPeopleCellBackground"))
                .padding(.bottom, -8)

                DiscountSectionView(viewModel: viewModel)
                    .animation(.none)

                HStack {
                    Button(action: { self.viewModel.dismiss() }) {
                        Text("Discard")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                    }
                    .background(Color("SettingsPeopleCellBackground"))
                    .padding(.trailing, -4)

                    Spacer()

                    Button(action: { self.viewModel.dismiss() }) {
                        Text("OK")
                            .bold()
                            .frame(maxWidth: .infinity, maxHeight: 44)
                    }
                    .disabled(!viewModel.isCorrect)
                    .background(Color("SettingsPeopleCellBackground"))
                    .padding(.leading, -4)
                }
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 8)
            .padding(.horizontal, 16)
            .offset(x: 0, y: -32)
        }
    }
}

struct DiscountPopover_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
