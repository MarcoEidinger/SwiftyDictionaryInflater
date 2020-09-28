import XCTest
@testable import SwiftyDictionaryInflater

final class SwiftyDictionaryInflaterTests: XCTestCase {
    func testExample() {
        XCTAssertNotNil(SwiftyDictionaryInflater().inflate(dictionary: [:]))
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
