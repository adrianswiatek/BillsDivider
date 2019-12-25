import SwiftUI

struct TabsView: View {
    private let viewModelFactory: ViewModelFactory
    private let receiptListViewModel: ReceiptListViewModel
    private let summaryViewModel: SummaryViewModel

    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self.receiptListViewModel = viewModelFactory.receiptListViewModel

        let positions = self.receiptListViewModel.$positions.eraseToAnyPublisher()
        self.summaryViewModel = viewModelFactory.summaryViewModel(positions: positions)
    }

    var body: some View {
        TabView {
            ReceiptView(viewModelFactory.receiptViewModel).tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }
//            ReceiptListView(receiptListViewModel, viewModelFactory).tabItem {
//                Image(systemName: "list.dash")
//                Text("Receipt")
//            }

            SummaryView(summaryViewModel).tabItem {
                Image(systemName: "doc.text")
                Text("Summary")
            }

            SettingsView(viewModelFactory.settingsViewModel).tabItem {
                Image(systemName: "hammer")
                Text("Settings")
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().tabsView
    }
}
