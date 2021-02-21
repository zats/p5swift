// Examples

import Foundation
import p5swift

class MySketch: Sketch, SketchSample {
  static let title = "My Sketch"
  static let author = "okazz"
  static let url = URL(string: "https://openprocessing.org/sketch/1085350/")!
  static let authorUrl = URL(string: "https://twitter.com/okazz_")!

  var colors: [Color] = [.red, .orange, .yellow, .grey, .purple, .white, .grey].shuffled()
  lazy var backgroundColor = colors.removeFirst()

  override func setup() {
    noLoop()
  }
  
  func drawRibbon(x: Float, y: Float, w: Float, num: Int) {
      var a = random(max: 10).rounded(.down) * .pi * 0.25
      let maxL = random(min: 100, max: 300)
      push()
      colors.shuffle()
      translate(by: Point(x: x, y: y))
      stroke(with: Color(grey: 0, alpha: 0.08))
      for i in 0..<num {
          let len = w + random(max: maxL) * random()
          var rol = random(max: 2).rounded(.down)
          var off: Float = 0
          if i == num - 1 {
              rol = 777
          }
          rotate(by: a)
          fill(with: colors[i % 2])
          beginShape()
          vertex(Point(x: -w / 2, y: 0))
          vertex(Point(x: w / 2, y: 0))
          if rol == 0 {
              vertex(Point(x: w / 2, y: len - 0.2))
              vertex(Point(x: -w / 2, y: len - w))
              off = w / 2
              a = -.pi / 2
          } else if rol == 1 {
              vertex(Point(x: w / 2, y: len - w))
              vertex(Point(x: -w / 2, y: len - 0.2))
              off = -w / 2
              a = .pi / 2
          } else {
              vertex(Point(x: w / 2, y: len))
              vertex(Point(x: -w / 2, y: len))
          }
          endShape(.close)
          translate(by: Point(x: off, y: len - w / 2))
      }
      pop()
  }

  func drawCircle(x: Float, y: Float, d: Float) {
      push()
      translate(by: Point(x: x, y: y))
      rotate(by: random(max: 8).rounded(.down) * .pi * 0.25)
      stroke(with: Color(grey: 0, alpha: 0.08))
      fill(with: colors.randomElement()!)
      ellipse(Ellipse(x: -d * 0.5, y: -d * 0.5, width: d, height: d))
      fill(with: colors.randomElement()!)
      arc(Arc(x: 0, y: 0, radius: d * 0.5, start: 0, stop: .pi))
      pop()
  }

  override func draw() {
    background(backgroundColor)
    for i in 0..<70 {
        print(i)
        let x = random(max: size.width)
        let y = random(max: size.height)
        let w = random(min: 5, max: 20)
        let d = random(min: 25, max: 45)
        let n = Int(random(min: 5, max: 20))
        let rnd = Int(random(max: 2))
        if rnd == 1 {
            drawRibbon(x: x, y: y, w: w, num: n)
        } else {
            drawCircle(x: x, y: y, d: d.rounded(.down))
        }
    }

  }
}
