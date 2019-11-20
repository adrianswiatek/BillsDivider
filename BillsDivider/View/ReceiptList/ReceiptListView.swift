import SwiftUI

struct ReceiptListView: View {
    @ObservedObject private var viewModel: ReceiptListViewModel = .init()
    @State private var presentingAddOverlay: Bool = false

    private let columnWidth: CGFloat = UIScreen.main.bounds.width / 3

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(viewModel.positions) {
                        ReceiptPositionView($0, self.columnWidth)
                            .offset(x: -24, y: 0)
                    }
                    .onDelete {
                        guard let index = $0.first else { return }
                        self.viewModel.removePosition(at: index)
                    }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.presentingAddOverlay = true }) {
                Image(systemName: "plus")
                    .frame(width: 24, height: 24)
            })
        }
        .sheet(isPresented: $presentingAddOverlay) {
            self.createAddOverlayView()
        }
    }

    private func createAddOverlayView() -> some View {
        let addOverlayViewModel = AddOverlayViewModel($presentingAddOverlay)
        viewModel.subscribe(to: addOverlayViewModel.positionAdded)
        return AddOverlayView(addOverlayViewModel)
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptListView()
    }
}
