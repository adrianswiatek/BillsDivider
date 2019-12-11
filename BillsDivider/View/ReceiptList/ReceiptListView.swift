import SwiftUI

struct ReceiptListView: View {
    @ObservedObject private var viewModel: ReceiptListViewModel

    @State private var editOverlayParams: EditOverlayViewParams = .hidden
    @State private var presentingOptionsMenu: Bool = false

    private let columnWidth: CGFloat = UIScreen.main.bounds.width / 3
    private let viewModelFactory: ViewModelFactory

    init(_ viewModel: ReceiptListViewModel, _ viewModelFactory: ViewModelFactory) {
        self.viewModel = viewModel
        self.viewModelFactory = viewModelFactory
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(viewModel.positions) { position in
                        ReceiptPositionView(position, self.columnWidth, self.viewModel.formatNumber)
                            .offset(x: -24, y: 0)
                            .contextMenu {
                                Button(action: {
                                    self.editOverlayParams = .shown(mode: .editing, position: position)
                                }) {
                                    Text("Edit position")
                                    Image(systemName: "pencil")
                                }
                            }
                    }
                    .onDelete {
                        guard let index = $0.first else { return }

                        withAnimation {
                            self.viewModel.removePosition(at: index)
                        }
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: { self.presentingOptionsMenu = true }) {
                    Image(systemName: "ellipsis")
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(90))
                }
                .disabled(viewModel.positions.isEmpty),
                trailing: Button(action: {
                    self.editOverlayParams = .shown(mode: .adding, position: self.viewModel.positions.first)
                }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
        }
        .sheet(isPresented: $editOverlayParams.show) {
            self.createEditOverlayView()
        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Remove all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func createEditOverlayView() -> some View {
        let editOverlayViewModel = viewModelFactory.editOverlayViewModel(presentingParams: $editOverlayParams)
        viewModel.subscribe(
            addingPublisher: editOverlayViewModel.positionAdded,
            editingPublisher: editOverlayViewModel.positionEdited
        )
        return EditOverlayView(editOverlayViewModel)
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptListView
    }
}
