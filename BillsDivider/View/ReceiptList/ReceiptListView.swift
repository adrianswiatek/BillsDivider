import SwiftUI

struct ReceiptListView: View {
    @ObservedObject private var viewModel: ReceiptListViewModel

    @State private var presentingEditOverlay: Bool = false
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
                    ForEach(viewModel.positions) {
                        ReceiptPositionView($0, self.columnWidth, self.viewModel.formatNumber)
                            .offset(x: -24, y: 0)
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
                trailing: Button(action: { self.presentingEditOverlay = true }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
        }
        .sheet(isPresented: $presentingEditOverlay) {
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
        let editOverlayViewModel = viewModelFactory.editOverlayViewModel(
            presenting: $presentingEditOverlay,
            receiptPosition: viewModel.positions.first
        )
        viewModel.subscribe(to: editOverlayViewModel.positionAdded)
        return EditOverlayView(editOverlayViewModel)
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().receiptListView
    }
}
