import XCTest

protocol Page {
    var isVisible: Bool { get }
    
    init(_ app: XCUIApplication)
}
