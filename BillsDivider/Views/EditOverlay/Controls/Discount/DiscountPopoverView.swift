import BillsDivider_ViewModel
import SwiftUI

struct DiscountPopoverView: View {
    @ObservedObject private var viewModel: DiscountPopoverViewModel

    init(_ viewModel: DiscountPopoverViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            overlayView

            VStack {
                headerView

                DiscountTextFieldView(viewModel)
                    .animation(.none)

                footerView
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 8)
            .padding(.horizontal, 16)
            .offset(x: 0, y: -32)
        }
    }

    private var overlayView: some View {
        Color.black
            .opacity(0.5)
            .edgesIgnoringSafeArea(.vertical)
    }

    private var headerView: some View {
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
    }

    private var footerView: some View {
        HStack {
            Button(action: { self.viewModel.dismiss() }) {
                Text("Discard")
                    .frame(maxWidth: .infinity, maxHeight: 44)
            }
            .padding(.trailing, -4)

            Button(action: { self.viewModel.confirm() }) {
                Text("OK")
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: 44)
            }
            .disabled(!viewModel.isValid)
            .padding(.leading, -4)
        }
        .background(Color("SettingsPeopleCellBackground"))
    }
}

struct DiscountPopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().discountPopoverView
    }
}
