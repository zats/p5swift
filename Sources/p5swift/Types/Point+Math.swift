// p5swift

import Foundation

public extension Point {
  static func + (lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x + rhs.x,
          y: lhs.y + rhs.y)
  }
}
