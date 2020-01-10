import SwiftUI

struct TabItem: Identifiable {
    let id: UUID = UUID()
    let title: String
    let imageName: String
    let view: AnyView
}
