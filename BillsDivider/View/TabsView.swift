import SwiftUI

struct TabsView: View {
    private let viewModelFactory: ViewModelFactory

    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }

    var body: some View {
        TabView {
            ReceiptView(viewModelFactory.receiptViewModel, viewModelFactory).tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }

            SummaryView(viewModelFactory.summaryViewModel).tabItem {
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
