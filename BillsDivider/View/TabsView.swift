import SwiftUI

struct TabsView: View {
    private let viewModelFactory: ViewModelFactory

    init(_ viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    var body: some View {
        TabView {
            ReceiptListView(viewModelFactory).tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }

            SummaryView(viewModelFactory.summaryViewModel).tabItem {
                Image(systemName: "doc.text")
                Text("Summary")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        TabsView(ViewModelFactory(numberFormatter: .twoFracionDigitsNumberFormatter))
    }
}
