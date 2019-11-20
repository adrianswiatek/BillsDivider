import SwiftUI

struct ReceiptListView: View {
    private let columnWidth = UIScreen.main.bounds.width / 3

    @ObservedObject private var viewModel: ReceiptListViewModel = .init()
    @State private var presentingAddOverlay = false

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(viewModel.positions) {
                        ReceiptPositionView($0, self.columnWidth)
                            .offset(x: -24, y: 0)
                    }
                    .onDelete { print($0.first ?? "") }
                }
            }
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: { self.presentingAddOverlay = true }) {
                Image(systemName: "plus")
                    .frame(width: 24, height: 24)
            })
        }
        .sheet(isPresented: $presentingAddOverlay) {
            AddOverlayView(self.$presentingAddOverlay)
        }
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptListView()
    }
}
