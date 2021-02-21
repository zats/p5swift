import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(RandomTests.allTests),
      testCase(ColorTests.allTests),
      testCase(p5swiftTests.allTests),
    ]
}
#endif
