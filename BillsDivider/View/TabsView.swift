import SwiftUI

struct TabsView: View {
    private var receiptListViewModel: ReceiptListViewModel = .init()

    var body: some View {
        TabView {
            ReceiptListView(receiptListViewModel).tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }

            SummaryView().tabItem {
                Image(systemName: "doc.text")
                Text("Summary")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView()
    }
}
