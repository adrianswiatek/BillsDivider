import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            ReceiptListView().tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }

            Text("Summary").tabItem {
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
