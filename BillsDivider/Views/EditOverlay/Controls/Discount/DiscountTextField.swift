import BillsDivider_ViewModel
import SwiftUI

struct DiscountSectionView: View {
    @ObservedObject private var viewModel: EditOverlayDiscountViewModel

    init(viewModel: EditOverlayDiscountViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.isCorrect ? "" : "Invalid discount")
                .font(.footnote)
                .foregroundColor(.secondary)

            ZStack {
                if !viewModel.text.isEmpty && viewModel.isCorrect {
                    HStack {
                        Spacer()
                        Text("-")
                            .foregroundColor(.primary)
                            .font(.system(size: 42, weight: .light, design: .rounded))
                        Text(viewModel.text.isEmpty ? viewModel.placeholder : viewModel.text)
                            .foregroundColor(.clear)
                    }
                }

                TextField(viewModel.placeholder, text: $viewModel.text)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .foregroundColor(viewModel.isCorrect ? .primary : .secondary)
            }
            .font(.system(size: 42, weight: .medium, design: .rounded))
        }
        .padding(.init(top: 4, leading: 16, bottom: 4, trailing: 16))
        .background(Color("ControlsBackground"))
        .padding(.vertical, -8)
    }
}

struct DiscountSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
