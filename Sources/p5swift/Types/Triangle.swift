// p5swift

import Foundation

public struct Triangle {
  public var a: Point
  public var b: Point
  public var c: Point
  
  public init(a: Point, b: Point, c: Point) {
    self.a = a
    self.b = b
    self.c = c
  }
  
  public var ab: Line {
    Line(a: a, b: b)
  }
  
  public var bc: Line {
    Line(a: b, b: c)
  }
  
  public var ca: Line {
    Line(a: c, b: a)
  }
}

public extension Triangle {
  static func equilateral(center: Point, radius: Float, angle: Float = 0) -> Triangle {
    let a = Point(angle: angle, radius: radius, origin: center)
    let b = Point(angle: angle + .twoPi / 3, radius: radius, origin: center)
    let c = Point(angle: angle + .twoPi / 3 * 2, radius: radius, origin: center)
    return Triangle(a: a, b: b, c: c)
  }
}

public extension Triangle {
  var area: Float {
    0.5 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
  }
}
