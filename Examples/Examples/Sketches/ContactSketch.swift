// Examples

import Foundation
import p5swift

class ContactSketch: Sketch, SketchSample {
  static let title = "Contact"
  static let author = "Roni Kaufman"
  static let authorUrl = URL(string: "https://twitter.com/kaufmanroni")!
  static let url = URL(string: "https://openprocessing.org/sketch/917163/")!

  private let step = random(min: 0.005, max: 0.01)
  private let kMax = random(min: 1, max: 2)
  private let n = 300
  private let radius: Float = 140
  private let maxNoise: Float = 20
  private var theta0 = random(max: .twoPi)
  
  override func setup() {
    noFill()
    noLoop()
  }
  
  override func draw() {
    background(Color(grey: 0.95))
    
    for i in 0..<n {
      var alpha = 1 - Float(i) / Float(n)
      if alpha > 0.5 {
        alpha = 1 - alpha
        stroke(with: Color(grey: 0.1, alpha: alpha))
        blob(size: radius, center: Point(x: size.width/2, y: size.height/2), k: kMax, t: Float(i) * step, noisiness: maxNoise)
      }
    }
  }
  
  private func blob(size: Float, center: Point, k: Float, t: Float, noisiness: Float) {
    beginShape()
    let angleStep: Float = .twoPi / 200
    let stop: Float = .twoPi + 5 * random(min: -angleStep, max: angleStep)
    for theta in stride(from: 0, to: stop, by: angleStep) {
      var r: Float
      if theta < stop / 2 {
        r = size + noise(x: k * theta, y: t * map(value: theta, start1: 0, stop1: stop/2, start2: 0, stop2: 1)) * noisiness
      } else {
        r = size + noise(x: k * theta, y: t * map(value: theta, start1: stop/2, stop1: stop, start2: 1, stop2: 0)) * noisiness
      }
      curveVertex(Point(angle: theta - theta0, radius: r, origin: center))
      let theta1 = random(max: .twoPi)
      if theta < stop / 2 {
        r = size + noise(x: k * theta1, y: t * map(value: theta1, start1: 0, stop1: stop / 2, start2: 0, stop2: 1))
      } else {
        r = size + noise(x: k * theta1, y: t * map(value: theta1, start1: stop / 2, stop1: stop, start2: 1, stop2: 0))
      }
      let sd = random(min: 5, max: 100)
      point(Point(angle: theta1 - theta0, radius: r, origin: center) + Point(x: randomGaussian(mean: 0, standardDeviation: sd), y: randomGaussian(mean: 0, standardDeviation: sd)))
    }
    endShape(.open)
  }
}

