import CoreGraphics

public struct Point {
  public var x: Float
  public var y: Float
  
  public init(x: Float, y: Float) {
    self.x = x
    self.y = y
  }
}

public extension Point {
  static let zero = Point(x: 0, y: 0)
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
