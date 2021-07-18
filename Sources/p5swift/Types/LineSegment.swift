// p5swiftTests

import Foundation

public struct LineSegment {
  public var a: Point
  public var b: Point
  
  public init(a: Point, b: Point) {
    self.a = a
    self.b = b
  }
}

public extension LineSegment {
  var length: Float {
    a.distance(to: b)
  }
}

public extension LineSegment {
  
  var isVertical: Bool {
    abs(a.x - b.x) < .ulpOfOne
  }
  
  var isHorizontal: Bool {
    abs(a.y - b.y) < .ulpOfOne
  }
  
  enum Intersection {
    case point(Point)
    case segment(LineSegment)
  }
  
  var mid: Point {
    return a.interpolated(to: b, t: 0.5)
  }
  
  /**
   Tests whether point `c` is on the line segment.
   Ensure first that point c is collinear to segment, and then check whether `c` is within the rectangle formed by segmet
   */
  func includes(_ c: Point) -> Bool {
    Point.orientation(a, b, c) == .collinear
      && min(a.x, b.x) <= c.x
      && c.x <= max(a.x, b.x)
      && min(a.y, b.y) <= c.y
      && c.y <= max(a.y, b.y)
  }
  
  /**
   Determines whether two segments intersect
   */
  func intersects(another: LineSegment) -> Bool {
    let c = another.a, d = another.b
    // Get the orientation of points p3 and p4 in relation
    // to the line segment (p1, p2)
    let o1 = Point.orientation(a, b, c);
    let o2 = Point.orientation(a, b, d);
    let o3 = Point.orientation(c, d, a);
    let o4 = Point.orientation(c, d, b);
    
    // If the points p1, p2 are on opposite sides of the infinite
    // line formed by (p3, p4) and conversly p3, p4 are on opposite
    // sides of the infinite line formed by (p1, p2) then there is
    // an intersection.
    if o1 != o2 && o3 != o4 {return true}
    
    // Collinear special cases (perhaps these if checks can be simplified?)
    return (o1 == .collinear && includes(c)) ||
      (o2 == .collinear && includes(d)) ||
      (o3 == .collinear && another.includes(a)) ||
      (o4 == .collinear && another.includes(b))
    
  }
  
  func getCommonEndpoints(with another: LineSegment) -> [Point] {
    let c = another.a, d = another.b
    var points: [Point] = []
    if a == c {
      points.append(a);
      if b == d {
        points.append(b)
      }
    } else if a == d {
      points.append(a)
      if b == c {
        points.append(b)
      }
    } else if b == c {
      points.append(b)
      if a == d {
        points.append(a)
      }
    } else if b == d {
      points.append(b)
      if a == c {
        points.append(a)
      }
    }
    return points;
  }
  
  func intersection(with another: LineSegment) -> Intersection? {
    if !intersects(another: another) {
      return nil
    }
    
    let c = another.a, d = another.b
    
    if a == b && b == c && c == d {
      return .point(a)
    }
    
    let endpoints = self.getCommonEndpoints(with: another)
    let n = endpoints.count
    
    // One of the line segments is an intersecting single point.
    // NOTE: checking only n == 1 is insufficient to return early
    // because the solution might be a sub segment.
    let singelton = a == b || c == d
    if n == 1 && singelton {
      return .point(endpoints[0])
    }
    
    // Segments are equal.
    if n == 2 {
      return .segment(LineSegment(a: endpoints[0], b: endpoints[1]))
    }
    
    let collinearSegments = Point.orientation(a, b, c) == .collinear && Point.orientation(a, b, d) == .collinear
    if collinearSegments {
      if includes(c) && includes(d) {
        // Segment #2 is enclosed in segment #1
        return .segment(LineSegment(a: c, b: d))
      } else if another.includes(a) && another.includes(b) {
        // Segment #1 is enclosed in segment #2
        return .segment(LineSegment(a: a, b: b))
      }
      // The subsegment is part of segment #1 and part of segment #2.
      // Find the middle points which correspond to this segment.
      
      let midPoint1 = includes(c) ? c : d
      let midPoint2 = another.includes(a) ? a : b
      
      // There is actually only one middle point!
      if midPoint1 == midPoint2 {
        return .point(midPoint1)
      }
      
      return .segment(LineSegment(a: midPoint1, b: midPoint2))
    }
    
    // Beyond this point there is a unique intersection point.
    if isVertical {
      let m = (d.y - c.y) / (d.x - c.x)
      let b = c.y - m * c.x
      return .point(Point(x: a.x, y: m * a.x + b))
    }
    
    if another.isVertical {
      let m = (b.y - a.y) / (b.x - a.x)
      let b = a.y - m * a.x
      return .point(Point(x: c.x, y: m * c.x + b))
    }
    
    let m1 = (b.y - a.y) / (b.x - a.x);
    let m2 = (d.y - c.y) / (d.x - c.x)
    let b1 = a.y - m1 * a.x;
    let b2 = c.y - m2 * c.x;
    return .point(Point(x: (b2 - b1) / (m1 - m2),
                        y: (m1 * b2 - m2 * b1) / (m1 - m2)))
  }
}

import CoreGraphics

public extension LineSegment {
  func perpendicular() -> LineSegment {
    return rotating(by: .pi / 2, around: mid)
  }

  func scaling(by value: Float, around aroundOrCenter: Point? = nil) -> LineSegment {
    let around = aroundOrCenter ?? mid
    return applying(CGAffineTransform
                      .identity
                      .translatedBy(x: CGFloat(around.x), y: CGFloat(around.y))
                      .scaledBy(x: CGFloat(value), y: CGFloat(value))
                      .translatedBy(x: -CGFloat(around.x), y: -CGFloat(around.y)))
  }

  func rotating(by angle: Float, around aroundOrCenter: Point? = nil) -> LineSegment {
    let around = aroundOrCenter ?? mid
    return applying(CGAffineTransform
                      .identity
                      .translatedBy(x: CGFloat(around.x), y: CGFloat(around.y))
                      .rotated(by: CGFloat(angle))
                      .translatedBy(x: -CGFloat(around.x), y: -CGFloat(around.y)))
  }
  
  func applying(_ transform: CGAffineTransform) -> LineSegment {
    LineSegment(a: a.applying(transform),
                b: b.applying(transform))
  }
}
