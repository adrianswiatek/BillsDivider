import BillsDivider_ViewModel
import SwiftUI

struct PriceSectionView: View {
    @ObservedObject private var viewModel: ValueViewModel

    init(viewModel: ValueViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        HStack {
            Text(viewModel.isCorrect ? "" : "Invalid price")
                .font(.footnote)
                .foregroundColor(.secondary)

            TextField(viewModel.placeholder, text: $viewModel.text)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 42, weight: .medium, design: .rounded))
                .keyboardType(.decimalPad)
                .padding(.horizontal)
                .foregroundColor(viewModel.isCorrect ? .primary : .secondary)
        }
        .padding(.init(top: 4, leading: 24, bottom: 4, trailing: 0))
    }
}

struct PriceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
