import BillsDivider_ViewModel
import SwiftUI

public struct EditReductionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: EditReductionViewModel

    public init(_ viewModel: EditReductionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            Form {
                reductionSection
                peopleSection
                editReductionSection
            }
            .navigationBarHidden(true)
        }
        .navigationTitle(Text("Edit reduction"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private var reductionSection: some View {
        Section {
            HStack {
                Text(viewModel.reduction.name)

                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color.red)
                    .opacity(viewModel.reduction.state.is(.invalid) ? 1 : 0)
                    .animation(.easeInOut)

                TextField("0.00", text: $viewModel.reduction.value)
                    .foregroundColor(viewModel.reduction.state.is(.invalid) ? .secondary : .primary)
                    .font(.system(size: CGFloat(viewModel.reduction.fontSize), weight: .bold, design: .monospaced))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }

    private var peopleSection: some View {
        Section {
            HStack {
                Text("Buyer")
                Spacer()
                Picker(viewModel.buyer.formatted, selection: $viewModel.buyer) {
                    ForEach(viewModel.buyers, id: \.self) {
                        Text($0.formatted).tag($0.formatted)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .animation(.none)
            }

            HStack {
                Text("Owner")
                Spacer()
                Picker(viewModel.owner.formatted, selection: $viewModel.owner) {
                    ForEach(viewModel.owners, id: \.self) {
                        Text($0.formatted).tag($0.formatted)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .animation(.none)
            }
        }
    }

    private var editReductionSection: some View {
        Section {
            Button(action: {
                viewModel.updateReduction()
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                    Text("Update reduction")
                    Spacer()
                }
            }
            .disabled(!viewModel.canUpdateReduction)
        }
    }
}

struct EditReductionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().editReductionView
                .preferredColorScheme(.light)

            PreviewFactory().editReductionView
                .preferredColorScheme(.dark)
        }
    }
}
