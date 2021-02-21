// Examples

import Foundation
import p5swift

class StrangeVibrationsSketch: Sketch, SketchSample {
  static let author = "Roni Kaufman"
  static let authorUrl = URL(string: "https://twitter.com/kaufmanroni")!
  static let title = "Strange Vibration"
  static let url = URL(string: "https://openprocessing.org/sketch/1051702/")!

  private var points: [(r: Float, theta: Float)] = []
  
  override func setup() {
    noStroke()
        
    for r in stride(from: 12, to: 200, by: 12) {
      let iMax = r / 2
      for i in 0..<iMax {
        let theta: Float = map(value: Float(i), start1: 0, stop1: Float(iMax), start2: 0, stop2: .twoPi)
        points.append((r: Float(r), theta: theta))
      }
    }
  }
  
  override func draw() {
    let f = Float(frameCount) / 25;
    let circleRadius: Float = 4
    background(.black)
    blendMode(.add)
    translate(by: Point(x: size.width / 2, y: size.height / 2))
    rotate(by: .pi / 2)
    for p in points {
      var disp = map(value: p.r, start1: 100, stop1: 192, start2: 70, stop2: 0)
      if p.r < 100 {
        disp = map(value: p.r, start1: 12, stop1: 100, start2: 0, stop2: 70)
      }
      let cost = cos(p.theta)
      let sint = sin(p.theta)
      let t = f + p.r / 70
      
      fill(with: Color(red: 1, green: 0, blue: 0))
      var val = cos(t) / 2 + 0.5
      var r = p.r + val * disp
      circle(x: r * cost, y: r * sint, radius: circleRadius)
      fill(with: Color(red: 0, green: 255, blue: 0))
      val = cos(t + 0.05) / 2 + 0.5
      r = p.r + val * disp
      circle(x: r * cost, y: r * sint, radius: circleRadius)
      fill(with: Color(red: 0, green: 0, blue: 255))
      val = cos(t + 0.1) / 2 + 0.5
      r = p.r + val * disp
      circle(x: r * cost, y: r * sint, radius: circleRadius)
    }
  }
}

