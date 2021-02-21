import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(randomTests.allTests),
      testCase(p5swiftTests.allTests),
    ]
}
#endif
