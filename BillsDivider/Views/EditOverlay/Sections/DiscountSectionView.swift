import BillsDivider_ViewModel
import SwiftUI

struct DiscountSectionView: View {
    @ObservedObject private var viewModel: ValueViewModel
    private var hideDiscount: () -> Void

    init(viewModel: ValueViewModel, hideDiscount: @escaping () -> Void) {
        self.viewModel = viewModel
        self.hideDiscount = hideDiscount
    }

    var body: some View {
        HStack {
            Button(
                action: {
                    withAnimation { self.hideDiscount() }
                },
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                }
            )

            Text(viewModel.isCorrect ? "" : "Invalid discount")
                .font(.footnote)
                .foregroundColor(.secondary)

            ZStack {
                if !viewModel.text.isEmpty && viewModel.isCorrect {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 28, weight: .light, design: .rounded))
                        Text(viewModel.text.isEmpty ? viewModel.placeholder : viewModel.text)
                            .foregroundColor(.clear)
                    }
                }

                TextField(viewModel.placeholder, text: $viewModel.text)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .foregroundColor(viewModel.isCorrect ? .primary : .secondary)
            }
            .font(.system(size: 28, weight: .medium, design: .rounded))
            .padding(.horizontal)
        }
        .padding(.init(top: 2, leading: 24, bottom: 2, trailing: 0))
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
