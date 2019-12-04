import SwiftUI

struct ReceiptListView: View {
    @ObservedObject private var viewModel: ReceiptListViewModel

    @State private var presentingAddOverlay: Bool = false
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
                trailing: Button(action: { self.presentingAddOverlay = true }) {
                    Image(systemName: "plus")
                        .frame(width: 32, height: 32)
                }
            )
        }
        .sheet(isPresented: $presentingAddOverlay) {
            self.createAddOverlayView()
        }
        .actionSheet(isPresented: $presentingOptionsMenu) {
            ActionSheet(title: Text("Actions"), buttons: [
                .destructive(Text("Remove all"), action: { self.viewModel.removeAllPositions() }),
                .cancel()
            ])
        }
    }

    private func createAddOverlayView() -> some View {
        let addOverlayViewModel = viewModelFactory.addOverlayViewModel(
            presenting: $presentingAddOverlay,
            receiptPosition: viewModel.positions.first
        )
        viewModel.subscribe(to: addOverlayViewModel.positionAdded)
        return AddOverlayView(addOverlayViewModel)
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModelFactory = ViewModelFactory(numberFormatter: .twoFracionDigitsNumberFormatter)
        return ReceiptListView(viewModelFactory.receiptListViewModel, viewModelFactory)
    }
}
