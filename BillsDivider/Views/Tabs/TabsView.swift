import SwiftUI

public struct TabsView: View {
    private let items: [TabItem]

    public init(items: [TabItem]) {
        self.items = items
    }

    public var body: some View {
        TabView {
            ForEach(items) { item in
                item.view.tabItem {
                    Image(systemName: item.imageName)
                    Text(item.title)
                }
            }
        }
    }
}

struct TabsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewFactory().tabsView
    }
}
