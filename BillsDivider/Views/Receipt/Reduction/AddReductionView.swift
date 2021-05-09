import BillsDivider_ViewModel
import SwiftUI

public struct AddReductionView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel: AddReductionViewModel

    public init(_ viewModel: AddReductionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            Form {
                MoneySectionView($viewModel.reduction)
                peopleSection
                addReductionSection
            }
            .navigationBarHidden(true)
        }
        .navigationTitle(Text("Add reduction"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { viewModel.initialize() }
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

    private var addReductionSection: some View {
        Section {
            Button(action: {
                viewModel.addReduction()
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                    Text("Add reduction")
                    Spacer()
                }
            }
            .disabled(!viewModel.canAddReduction)
        }
    }
}

struct AddReductionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PreviewFactory().addReductionView
                .preferredColorScheme(.light)

            PreviewFactory().addReductionView
                .preferredColorScheme(.dark)
        }
    }
}
