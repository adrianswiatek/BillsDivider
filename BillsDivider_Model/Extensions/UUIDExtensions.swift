import Foundation

extension UUID {
    static var empty: UUID {
        guard let uuid = UUID(uuidString: "00000000-0000-0000-0000-000000000000") else {
            fatalError("Unable to create UUID from given string")
        }
        
        return uuid
    }
}
