import BillsDivider_ViewModel
import SwiftUI

struct DiscountTextFieldView: View {
    @ObservedObject private var viewModel: DiscountPopoverViewModel

    init(_ viewModel: DiscountPopoverViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.validationMessage)
                .font(.footnote)
                .foregroundColor(.secondary)

            ZStack {
                if !viewModel.text.isEmpty && viewModel.isValid {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 42, weight: .light, design: .rounded))
                        Text(viewModel.text.isEmpty ? viewModel.placeholder : viewModel.text)
                            .foregroundColor(.clear)
                    }
                }

                DiscountPopoverTextField(viewModel)
                    .frame(height: 56)
            }
            .font(.system(size: 42, weight: .medium, design: .rounded))
        }
        .padding(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
        .background(Color("ControlsBackground"))
        .padding(.vertical, -8)
    }
}

struct DiscountTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().discountTextFieldView
    }
}
