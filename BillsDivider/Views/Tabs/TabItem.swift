import SwiftUI

public struct TabItem: Identifiable {
    public let id: UUID = UUID()
    public let title: String
    public let imageName: String
    public let view: AnyView
}
