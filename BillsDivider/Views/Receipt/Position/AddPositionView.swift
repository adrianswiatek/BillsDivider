import BillsDivider_ViewModel
import SwiftUI

public struct AddPositionView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @ObservedObject private var viewModel: AddPositionViewModel

    public init(_ viewModel: AddPositionViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Form {
                    MoneySectionView($viewModel.price)
                    MoneySectionView($viewModel.discount)
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
        .onDisappear { presentationMode.wrappedValue.dismiss() }
    }

    private var positionAddedView: some View {
        Text("Position added")
            .font(.title2)
            .foregroundColor(.white)
            .padding()
            .background(
                Color.accentColor.shadow(
                    color: Color(UIColor(white: 0, alpha: 0.5)),
                    radius: 10,
                    x: 0,
                    y: 5
                )
            )
            .opacity(viewModel.isConfirmationVisible ? 1 : 0)
            .offset(x: 0, y: UIScreen.main.bounds.height / 4)
            .animation(.easeInOut(duration: 0.3))
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
