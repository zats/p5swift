// p5swift

import Foundation


public struct CubicBezier {

  public var p1: Point
  public var p2: Point
  public var c1: Point
  public var c2: Point

  public init(p1: Point, p2: Point, c1: Point, c2: Point) {
    self.p1 = p1
    self.p2 = p2
    self.c1 = c1
    self.c2 = c2
  }

  public init(p1: Point, p2: Point, smoothing: Float) {
    let p2p1 = p2 - p1
    let p3p2 = p1 - p2
    let p2p1Angle = p2p1.angle() - Float.pi / 6
    let p3p2Angle = p3p2.angle() + Float.pi / 6
    let c1 = Point(angle: p2p1Angle,
                   radius: p2p1.magnitude() * smoothing,
                   origin: p1)
    let c2 = Point(angle: p3p2Angle,
                   radius: p3p2.magnitude() * smoothing,
                   origin: p2)
    self.init(p1: p1, p2: p2, c1: c1, c2: c2)
  }

  public func point(at t: Float) -> Point {
    let a: Point = pow(1 - t, 3) * p1
    let b: Point = 3 * pow(1 - t, 2) * t * c1
    let c: Point = 3 * (1 - t) * t * t * c2
    let d: Point = t * t * t * p2
    return a + b + c + d
  }

  public func angle(at t: Float) -> Float {
    // following expression broken down into components to help compiler
    let _p0: Point = -3 * (pow(1-t, 2)) * p1
    let _p1: Point = 3 * (pow(1-t, 2)) * c1 - 6 * t * (1-t) * c1
    let _p2: Point = 3 * (t * t) * c2 + 6 * t * (1 - t) * c2
    let _p3: Point = 3 * (t * t) * p2
    let der: Point = _p0 + _p1 - _p2 + _p3
    return atan2(der.y, der.x)
  }

  public func simplified(n: Int) -> [LineSegment] {
    let points = stride(from: Float(0), through: 1, by: 1/Float(n))
      .map {
        self.point(at: $0)
      }
    return points
      .enumerate(by: 2, step: 1)
      .dropLast()
      .map { LineSegment(a: $0[0], b: $0[1] )}
  }

  public func length(simplification: Int = 10) -> Float {
    return simplified(n: simplification).reduce(0, { $0 + $1.length })
  }

//  public func intersection(with ray: Ray, simplification: Int = 10) -> Point? {
//    return simplified(n: simplification)
//      .compactMap({
//        ray.intersection(with: $0)
//      }).sorted(by: {
//        ray.origin.distance(to: $0) < ray.origin.distance(to: $1)
//      }).first
//  }

  public func split(at t: Float) -> (left: CubicBezier?, right: CubicBezier?) {
    let q = hull(at: t).vertices
    let left = CubicBezier(p1: q[0], p2: q[9], c1: q[4], c2: q[7])
    let right = CubicBezier(p1: q[9], p2: q[3], c1: q[8], c2: q[6])
    if t == 0 {
      return (left: nil, right: right)
    } else if t == 1 {
      return (left: left, right: nil)
    } else {
      return (left: left, right: right)
    }
  }

  public func hull(at t: Float) -> Polygon {
    var p = [self.p1, self.c1, self.c2, self.p2]
    var q = p
    while p.count > 1 {
      var _p: [Point] = []
      let l = p.count - 1
      for i in 0..<l {
        let pt = p[i].interpolated(to: p[i+1], t: t)
        q.append(pt);
        _p.append(pt);
      }
      p = _p;
    }
    return Polygon(vertices: q)
  }
}


//public extension CGContext {
//  func addCubicBeizer(_ curve: CubicBezier) {
//    self.move(to: curve.p1)
//    self.addCurve(to: curve.p2, control1: curve.c1, control2: curve.c2)
//  }
//}

public struct QuadraticBezier {
  public var p1: Point
  public var p2: Point
  public var p3: Point
  
  public init(p1: Point, p2: Point, p3: Point) {
    self.p1 = p1
    self.p2 = p2
    self.p3 = p3
  }
  
  func point(at t: Float) -> Point {
    let reverseT = 1 - t
    let reverseTSquared = reverseT * reverseT
    let tSquared = t * t
    return Point(x: reverseTSquared * p1.x + 2 * reverseT * t * p2.x + tSquared * p3.x,
                 y: reverseTSquared * p1.y + 2 * reverseT * t * p2.y + tSquared * p3.y)
  }
}

import CoreGraphics

extension CubicBezier {
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.move(to: p1.cgPoint)
    path.addCurve(to: p2.cgPoint, control1: c1.cgPoint, control2: c2.cgPoint)
    return path
  }
}

extension QuadraticBezier {
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.move(to: p1.cgPoint)
    path.addQuadCurve(to: p3.cgPoint, control: p2.cgPoint)
    return path
  }
}
