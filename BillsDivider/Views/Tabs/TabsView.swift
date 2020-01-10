import SwiftUI

struct TabsView: View {
    private let items: [TabItem]

    init(items: [TabItem]) {
        self.items = items
    }

    var body: some View {
        TabView {
            ForEach(items) { item in
                item.view.tabItem {
                    Image(systemName: item.imageName)
                    Text(item.title)
                }
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
