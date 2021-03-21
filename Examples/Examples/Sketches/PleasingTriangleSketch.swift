// Examples

import Foundation
import p5swift


struct Attachment {
  var host: Triangle
  var generation: Int
}

class PleasingTraiangleSketch: Sketch, SketchSample {
  static var title = "Aesthetically pleasing triangle subdivision"
  static var author = "Sash Zats"
  static var authorUrl = URL(string: "https://www.instagram.com/zatss/")!
  static var url: URL? = nil
  
  var triangles: [Attachment] = []
  
  override func draw() {
    background(.black)
    
    noStroke()
    randomSeed(0xC0FE)

    let rect = safeFrame.insetBy(dx: 40, dy: 40)
    
    // draw
    fill(with: Color(grey: 1, alpha: 0.3))
    let step = min(rect.width / 20, rect.height / 20)
    let grid = rect.insetBy(dx: -step * 3, dy: -step * 3)
    grid.iterate(by: step) { point in
      circle(center: point, radius: 1)
    }

    triangles = [
      Attachment(host: Triangle(a: rect.topLeft, b: rect.bottomLeft, c: rect.bottomRight),
                 generation: 0),
      Attachment(host: Triangle(a: rect.bottomRight, b: rect.topRight, c: rect.topLeft),
                 generation: 0)
    ]

    let totalGenerations = 120
    for _ in 0..<totalGenerations {
      triangles.sort { $0.host.area < $1.host.area }
      var newTriangles: [Attachment] = []
      for triangle in triangles[0..<2] {
        newTriangles.append(contentsOf: split(triangle.host).map{
          Attachment(host: $0, generation: triangle.generation + 1)
        })
      }
      newTriangles.append(contentsOf: triangles[2...])
      triangles = newTriangles
    }

    // draw
    noFill()
    stroke(with: Color(grey: 1, alpha: 0.5))
    
    let maxGeneration = Float(triangles.max { $0.generation < $1.generation }!.generation)
    let minGeneration = Float(triangles.min { $0.generation < $1.generation }!.generation)
    
    for triangle in triangles {
      let generation = triangle.generation
      let triangle = triangle.host
      fill(with: Color(grey: 1, alpha: (Float(generation) - minGeneration) / (maxGeneration - minGeneration)))
      beginShape()
      vertex(triangle.a)
      vertex(triangle.b)
      vertex(triangle.c)
      vertex(triangle.a)
      endShape(.close)
    }
  }
  
  private func split(_ triangle: Triangle) -> [Triangle] {
    let abL = triangle.ab.length
    let bcL = triangle.bc.length
    let caL = triangle.ca.length
    if abL > bcL && abL > caL {
      // ab is the longest side
      let abRandom = lerp(start: triangle.a, stop: triangle.b, amount: random())
      return [
        Triangle(a: triangle.c, b: triangle.a, c: abRandom),
        Triangle(a: abRandom, b: triangle.b, c: triangle.c)
      ]
    } else if bcL > abL && bcL > caL {
      // bc is the longest side
      let bcRandom = lerp(start: triangle.b, stop: triangle.c, amount: random())
      return [
        Triangle(a: triangle.a, b: triangle.b, c: bcRandom),
        Triangle(a: bcRandom, b: triangle.c, c: triangle.a)
      ]
    } else {
      // ca is the longest side
      let caRandom = lerp(start: triangle.c, stop: triangle.a, amount: random())
      return [
        Triangle(a: triangle.b, b: triangle.c, c: caRandom),
        Triangle(a: caRandom, b: triangle.a, c: triangle.b),
      ]
    }
  }
}


