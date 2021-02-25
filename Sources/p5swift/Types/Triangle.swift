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
  var area: Float {
    0.5 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
  }
}
