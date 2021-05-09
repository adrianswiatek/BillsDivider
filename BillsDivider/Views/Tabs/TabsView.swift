import SwiftUI

public struct TabsView: View {
    private let coordinator: TabsViewCoordinator

    public init(_ coordinator: TabsViewCoordinator) {
        self.coordinator = coordinator
    }

    public var body: some View {
        TabView {
            coordinator.receiptView.tabItem {
                Image(systemName: "list.dash")
                Text("Receipt")
            }

            coordinator.summaryView.tabItem {
                Image(systemName: "doc.text")
                Text("Summary")
            }

            coordinator.settingsView.tabItem {
                Image(systemName: "hammer")
                Text("Summary")
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().tabsView
    }
}
