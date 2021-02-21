import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
      testCase(RandomTests.allTests),
      testCase(ColorTests.allTests),
      testCase(SketchSnapshotTestsTests.allTests),
    ]
}
#endif
