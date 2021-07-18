// Examples

import Foundation
import p5swift
import SceneKit

class CurvesSketch: Sketch, SketchSample {
  static let title = "Curves"
  static let author = "zats"
  static let authorUrl = URL(string: "https://twitter.com/zats")!
  static let url: URL? = nil
  
  var curves: [[QuadraticBezier]] = []

  override func setup() {
    func petal(top: Point, bottom: Point) -> [QuadraticBezier] {
      let direction = LineSegment(a: top, b: bottom)
      let crossAxis = direction.perpendicular()//.scaling(by: .random(in: 1...2))
      
      let a = direction.a
      let b = direction.b
      
      let adjustedMidA = crossAxis.a //+ delta.normalize() * .random(in: 0...maxDistance)
      let adjustedMidB = crossAxis.b //+ delta.normalize() * .random(in: 0...maxDistance)
      
      return stride(from: adjustedMidA, to: adjustedMidB, byDistance: 10).map {
        QuadraticBezier(p1: a,
                        p2: $0,
                        p3: b)
      }
    }
    
    let p = Polygon(numberOfVertices: 6, radius: 200, center: center, orientation: 0)
    for v in p.vertices {
      let polygon = Polygon(numberOfVertices: 6, radius: 100, center: v, orientation: 0)
      polygon.lineSegments.forEach {
        curves.append(petal(top: polygon.center, bottom: $0.mid))
      }
    }

    
    
//    polygon.vertices.enumerate(by: 2, step: 1, wrap: true).forEach {
//      var currentCurves: [QuadraticBezier] = []
//      let start = $0[0]
//      let end = $0[1]
//
//      let delta = end - start
//
//
//      let top = Point(angle: delta.angle() - .pi / 2,
//                      radius: delta.magnitude(),
//                      origin: start + delta * 0.5)
//      let bottom = Point(angle: delta.angle() + .pi / 2,
//                         radius: delta.magnitude(),
//                         origin: start + delta * 0.5)
//
//      currentCurves.append(QuadraticBezier(p1: start,
//                                           p2: top,
//                                           p3: end))
//      stride(from: top, to: bottom, byDistance: 10).forEach {
//        currentCurves.append(QuadraticBezier(p1: start, p2: $0, p3: end))
//      }
//
//      curves.append(currentCurves)
//    }
  }
  
  override func draw() {
    background(.black)
    stroke(with: .white)
    noFill()
    
    
    curves.forEach {
      $0.forEach {
        curve($0)
      }
    }
  }
}
