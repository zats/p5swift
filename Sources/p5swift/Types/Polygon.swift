// p5swift

import Foundation
import CoreGraphics

public struct Polygon {
  public var vertices: [Point]

  public init(vertices: [Point]) {
    self.vertices = vertices
  }
}

public extension Polygon {
  init(numberOfVertices: Int, radius: Float, center: Point, orientation: Float) {
    self.init(vertices: stride(from: 0, to: Float.pi * 2, by: Float.pi * 2 / Float(numberOfVertices)).map {
      Point(angle: $0 + orientation, radius: radius, origin: center)
    })
  }
}

public extension Polygon {
  /**
   Converts `CGRect` to `Polygon` in the counterclockwise order:
    1. top-left
    2. bottom-left
    3. bottom-right
    4. top-right
   */
  init(rect: Rectangle) {
    self.vertices = [
      Point(x: rect.minX, y: rect.minY),
      Point(x: rect.minX, y: rect.maxY),
      Point(x: rect.maxX, y: rect.maxY),
      Point(x: rect.maxX, y: rect.minY),
    ]
  }
  
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.addLines(between: self.vertices.map { $0.cgPoint })
    path.closeSubpath()
    return path
  }
}


public extension Polygon {
  var center: Point {
    vertices.reduce(.zero, { $0 + $1 }) / Float(vertices.count)
  }
  
  var lineSegments: [LineSegment] {
    return vertices.enumerate(by: 2, step: 1, wrap: true).map {
      LineSegment(a: $0[0], b: $0[1])
    }
  }
}
