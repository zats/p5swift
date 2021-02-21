import XCTest
@testable import p5swift

final class p5swiftTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(p5swift().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
