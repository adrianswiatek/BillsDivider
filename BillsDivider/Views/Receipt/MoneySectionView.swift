import BillsDivider_ViewModel
import SwiftUI

struct MoneySectionView: View {
    @Binding private var viewModel: MoneyViewModel

    public init(_ viewModel: Binding<MoneyViewModel>) {
        self._viewModel = viewModel
    }

    var body: some View {
        Section {
            HStack {
                Text(viewModel.name)

                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color.red)
                    .opacity(viewModel.state.is(.invalid) ? 1 : 0)
                    .animation(.easeInOut)

                TextField("0.00", text: $viewModel.value)
                    .foregroundColor(viewModel.state.is(.invalid) ? .secondary: .primary)
                    .font(.system(
                        size: CGFloat(viewModel.fontSize),
                        weight: .bold,
                        design: .monospaced
                    ))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct MoneySectionView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().moneySectionView
    }
}
