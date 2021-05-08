import BillsDivider_ViewModel
import SwiftUI

public struct EditPositionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject private var viewModel: EditPositionViewModel

    public init(_ viewModel: EditPositionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            Form {
                moneySection(for: $viewModel.price)
                moneySection(for: $viewModel.discount)
                peopleSection
                updatePositionSection
            }
            .navigationBarHidden(true)
        }
        .navigationTitle(Text("Edit position"))
        .navigationBarTitleDisplayMode(.inline)
    }

    private func moneySection(for viewModel: Binding<MoneyViewModel>) -> some View {
        let name = viewModel.wrappedValue.name
        let isValid = viewModel.wrappedValue.state.is(.invalid) == false
        let fontSize = CGFloat(viewModel.wrappedValue.fontSize)

        return Section {
            HStack {
                Text(name)

                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Color.red)
                    .opacity(isValid ? 0 : 1)
                    .animation(.easeInOut)

                TextField("0.00", text: viewModel.value)
                    .foregroundColor(isValid ? .primary : .secondary)
                    .font(.system(size: fontSize, weight: .bold, design: .monospaced))
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

    private var updatePositionSection: some View {
        Section {
            Button {
                viewModel.updatePosition()
                presentationMode.wrappedValue.dismiss()
            } label: {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                    Text("Update position")
                    Spacer()
                }
            }
            .disabled(!viewModel.canUpdatePosition)
        }
    }
}

struct EditPositionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().editPositionView
                .preferredColorScheme(.light)

            PreviewFactory().editPositionView
                .preferredColorScheme(.dark)
        }
    }
}
