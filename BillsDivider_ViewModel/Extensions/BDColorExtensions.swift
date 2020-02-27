import BillsDivider_Model
import SwiftUI

extension BDColor {
    public var asColor: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        case .orange: return .orange
        default: preconditionFailure("Unhandled color")
        }
    }
}

extension Color {
    public var asBDColor: BDColor {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        case .orange: return .orange
        default: preconditionFailure("Unhandled color")
        }
    }
}
