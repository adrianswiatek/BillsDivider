import XCTest

extension XCUIElement {
    func tapWithDelay(delayInSeconds: TimeInterval = 0.5) {
        Thread.sleep(forTimeInterval: delayInSeconds)
        tap()
    }

    func typeTextWithDelay(_ text: String, delayInSeconds: TimeInterval = 0.5) {
        Thread.sleep(forTimeInterval: delayInSeconds)
        typeText(text)
    }
}
