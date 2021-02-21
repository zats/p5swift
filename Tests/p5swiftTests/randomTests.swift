// p5swiftTests

import XCTest
@testable import p5swift

final class randomTests: XCTestCase {
  func testRandom() {
    randomSeed(0xC0FE)
    let r = random(min: 0, max: 1)
    XCTAssert(r == 0.472526878)
  }
  
  func test1DNoise() {
    noiseSeed(0xC0FE)
    randomSeed(0xC0FE)
    let n = noise(x: 0.5)
    XCTAssert(n == -0.286022455)
  }
  
  func test2DNoise() {
    noiseSeed(0xC0FE)
    let n = noise(x: 0.5, y: 0.5)
    XCTAssert(n == 0.649006724)
  }
  
  func testGaussian() {
    randomGaussianSeed(0xC0FE)
    let g = randomGaussian(mean: 0, standardDeviation: 10)
    XCTAssert(g == -1.05022883)
  }
  
  static var allTests = [
    ("testRandom", testRandom),
    ("test1DNoise", test1DNoise),
    ("test2DNoise", test2DNoise),
    ("testGaussian", testGaussian),
  ]
}
