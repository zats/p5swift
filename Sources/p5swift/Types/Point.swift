import CoreGraphics

public struct Point {
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
  func magnitudeSquared() -> Float {
    x * x + y * y + z * z
  }
  
  func magnitude() -> Float {
    sqrt(magnitudeSquared())
  }
}

public extension Point {
  func distance(to another: Point) -> Float {
    sqrt(distanceSquared(to: another))
  }
  
  func distanceSquared(to another: Point) -> Float {
    let delta = another - self
    return delta.magnitudeSquared()
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
}
