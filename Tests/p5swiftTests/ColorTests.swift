// p5swiftTests

import XCTest
@testable import p5swift

final class ColorTests: XCTestCase {
  func testHex3() {
    XCTAssert(Color(hex: "000") ≈ Color(red: 0, green: 0, blue: 0))
    XCTAssert(Color(hex: "#000") ≈ Color(red: 0, green: 0, blue: 0))
    XCTAssert(Color(hex: "5AF") ≈ Color(red: 0.33, green: 0.67, blue: 1))
    XCTAssert(Color(hex: "#00f") ≈ Color(red: 0, green: 0, blue: 1))
    XCTAssert(Color(hex: "#00z") ≈ .hexFallbackColor)
  }
  
  func testHex4() {
    XCTAssert(Color(hex: "#00f8") ≈ Color(red: 0, green: 0, blue: 1, alpha: 0.53))
    XCTAssert(Color(hex: "00F8") ≈ Color(red: 0, green: 0, blue: 1, alpha: 0.53))
    XCTAssert(Color(hex: "A5AF") ≈ Color(red: 0.67, green: 0.33, blue: 0.67, alpha: 1))
    XCTAssert(Color(hex: "z5AF") ≈ .hexFallbackColor)
  }
  
  func testHex6() {
    XCTAssert(Color(hex: "0000FF") ≈ Color(red: 0, green: 0, blue: 1))
    XCTAssert(Color(hex: "#FF00FF") ≈ Color(red: 1, green: 0, blue: 1))
    XCTAssert(Color(hex: "ZZ55AAFF") ≈ .hexFallbackColor)
  }

  func testHex8() {
    XCTAssert(Color(hex: "0000FF7F") ≈ Color(red: 0, green: 0, blue: 1, alpha: 0.5))
    XCTAssert(Color(hex: "#7F00FF7F") ≈ Color(red: 0.5, green: 0, blue: 1, alpha: 0.5))
    XCTAssert(Color(hex: "ZZ55AAFF") ≈ .hexFallbackColor)
  }

  static let allTests = [
    ("testHex3", testHex3),
    ("testHex4", testHex4)
  ]
}

infix operator ≈ : DefaultPrecedence

private extension Color {
  static func ≈ (lhs: Color, rhs: Color) -> Bool {
    abs(lhs.red - rhs.red) < 0.01 &&
      abs(lhs.green - rhs.green) < 0.01 &&
      abs(lhs.blue - rhs.blue) < 0.01 &&
      abs(lhs.alpha - rhs.alpha) < 0.01
  }
}
