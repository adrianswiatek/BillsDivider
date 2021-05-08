import BillsDivider_ViewModel
import SwiftUI

public struct AddPositionView: View {
    @ObservedObject private var viewModel: AddPositionViewModel

    public init(_ viewModel: AddPositionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Form {
                    moneySection(for: $viewModel.price)
                    moneySection(for: $viewModel.discount)
                    peopleSection
                    addPositionSection
                }

                positionAddedView
            }
            .navigationBarHidden(true)
        }
        .navigationTitle(Text("Add position"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.initialize() }
    }

    private var positionAddedView: some View {
        Text("Position added")
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(
                Color.accentColor.shadow(
                    color: Color(UIColor(white: 0, alpha: 0.5)), radius: 10, x: 0, y: 5
                )
            )
            .opacity(viewModel.isConfirmationVisible ? 1 : 0)
            .offset(x: 0, y: UIScreen.main.bounds.height / 4)
            .animation(.easeInOut(duration: 0.3))
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

    private var addPositionSection: some View {
        Section {
            Button(action: { viewModel.addPosition() }) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                    Text("Add position")
                    Spacer()
                }
            }
            .disabled(!viewModel.canAddPosition)
        }
    }
}

struct AddPositionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().addPositionView
                .preferredColorScheme(.light)

            PreviewFactory().addPositionView
                .preferredColorScheme(.dark)
        }
    }
}
