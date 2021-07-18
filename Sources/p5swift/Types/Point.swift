import CoreGraphics

public struct Point: Equatable {
  public var x: Float
  public var y: Float
  public var z: Float
  
  public init(x: Float, y: Float, z: Float = 0) {
    self.x = x
    self.y = y
    self.z = z
  }
}

public extension Point {
  func normalize() -> Point {
    let magnitude = self.magnitude()
    return Point(x: x / magnitude, y: y / magnitude, z: z / magnitude)
  }
  
  func magnitudeSquared() -> Float {
    x * x + y * y + z * z
  }
  
  func magnitude() -> Float {
    sqrt(magnitudeSquared())
  }

  func distance(to another: Point) -> Float {
    sqrt(distanceSquared(to: another))
  }
  
  func distanceSquared(to another: Point) -> Float {
    let delta = another - self
    return delta.magnitudeSquared()
  }
  
  func angle() -> Float {
    return atan2(y, x)
  }

}

public extension Point {
  func interpolte(to target: Point, by amount: Float) -> Point {
    self + (target - self).normalize() * amount
  }
}

public extension Point {
  static let zero = Point(x: 0, y: 0, z: 0)
}

public extension Point {
  init(cgPoint: CGPoint) {
    self.init(x: Float(cgPoint.x), y: Float(cgPoint.y))
  }
  
  var cgPoint: CGPoint {
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
  }
}

public extension Point {
  init(angle: Float, radius: Float, origin: Point = .zero) {
    self.init(x: cos(angle) * radius + origin.x,
              y: sin(angle) * radius + origin.y)
  }
}

public extension Point {
  static func + (lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x + rhs.x,
          y: lhs.y + rhs.y,
          z: lhs.z + rhs.z)
  }

  static func - (lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x - rhs.x,
          y: lhs.y - rhs.y,
          z: lhs.z - rhs.z)
  }

  static func * (rhs: Float, lhs: Point) -> Point {
    Point(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
  }

  static func * (lhs: Point, rhs: Float) -> Point {
    Point(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
  }

  static func / (rhs: Float, lhs: Point) -> Point {
    Point(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
  }

  static func / (lhs: Point, rhs: Float) -> Point {
    Point(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
  }
  
  static func *= (lhs: inout Point, rhs: Float) {
    lhs = lhs * rhs
  }
}

public extension Point {
  enum Orientation {
    case collinear
    case clockwise
    case counterClockwise
  }

  /**
   Finds the orientation of point `c` relative to the line segment (a, b)
   - Returns: `clockwise` if `c`is clockwise to segment (a, b), i.e right of line formed by the segment;  `counterClockwise` if `c` is counter clockwise to segment (`a`, `b`), i.e left of line formed by the segment
   */
  static func orientation(_ a: Point, _ b: Point, _ c: Point) -> Orientation {
    precondition(a.z == 0 && b.z == 0 && c.z == 0, "3D orientation not implemented")
    let value = (b.y - a.y) * (c.x - b.x) - (b.x - a.x) * (c.y - b.y)
    if abs(value) < .ulpOfOne {
      return .collinear
    } else if value > 0 {
      return .clockwise
    } else {
      return .counterClockwise
    }
  }
}

public extension Point {
  /// Interpolates between `self` and `other` points by value `t`
  func interpolated(to other: Point, t: Float) -> Point {
    return self + (other - self) * t
  }

  func interpolated(to other: Point, by distance: Float) -> Point {
    return self.interpolated(to: other, t: distance / self.distance(to: other))
  }
}

public extension Point {
  static func random(in rect: Rectangle) -> Point {
    return Point(x: Float.random(in: rect.minX...rect.maxX),
                 y: Float.random(in: rect.minX...rect.maxX))
  }
}

public func stride(from: Point, to: Point, byDistance: Float) -> [Point] {
  let distance = from.distance(to: to)
  return stride(from: 0, through: 1, by: byDistance / distance).map {
    lerp(start: from, stop: to, amount: $0)
  }
}

public extension Point {
  func applying(_ transform: CGAffineTransform) -> Point {
    return Point(cgPoint: cgPoint.applying(transform))
  }
}
