import SwiftUI

struct ReceiptListView: View {
    private let columnWidth = UIScreen.main.bounds.width / 3

    @State private var presentingAddOverlay = false

    private var positions = [
        ReceiptPosition(amount: 2.5, buyer: .me, owner: .notMe),
        ReceiptPosition(amount: 12.99, buyer: .me, owner: .notMe),
        ReceiptPosition(amount: 7.49, buyer: .me, owner: .all),
        ReceiptPosition(amount: 4, buyer: .notMe, owner: .me),
        ReceiptPosition(amount: 0.97, buyer: .notMe, owner: .all)
    ]

    var body: some View {
        NavigationView {
            List {
                Section(header: ReceiptHeaderView(columnWidth)) {
                    ForEach(positions) {
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
            AddOverlayView(presenting: self.$presentingAddOverlay)
        }
    }
}

struct ReceiptListView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptListView()
    }
}