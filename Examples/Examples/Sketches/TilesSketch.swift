// Examples

import Foundation
import p5swift

class TilesSketch: Sketch, SketchSample {
  static var title = "mySketch"
  static var author = "Takawo Shunsuke"
  static var authorUrl = URL(string: "https://twitter.com/takawo")!
  static var url = URL(string: "https://openprocessing.org/sketch/1102980")
  
  override func setup() {
    randomSeed(0xC0FE)
    noLoop()
  }
  
  override func draw() {
    background(Color(grey: 0.95))
    
    let offset = width / 10;
    var x = -offset
    var y = -offset
    let w = width + offset;
    let h = height + offset;
    var xStep: Float = 0
    var yStep :Float = 0
    
    
    while (y < h) {
      yStep = random(min: h / 8, max: h / 2) / 2;
      x = -offset;
      if (y + yStep > h) {
        yStep = h - y
      }
      while (x < w) {
        xStep = random(min: w / 8, max: w / 2) / 2
        if x + xStep > w {
          xStep = w - x
        }
        drawConnectedNode(x: x, y: y, width: xStep, height: yStep)
        x += xStep
      }
      y += yStep
    }
  }
  
  let palette: [Color] = [
    Color(hex: "264653"),
    Color(hex: "2a9d8f"),
    Color(hex: "e9c46a"),
    Color(hex: "f4a261"),
    Color(hex: "e76f51")
  ]
  
  func drawConnectedNode(x: Float, y: Float, width: Float, height: Float) {
    let colors = palette.shuffled()
    push();
    translate(by: Point(x: x, y: y))
    stroke(with: Color(grey: 0.2))
    noStroke();
    fill(with: colors[0]);
    let sep: Float = 20;
    rectangle(Rectangle(x: width / sep,
                        y: height / sep,
                        width: width * (sep - 2) / sep,
                        height: height * (sep - 2) / sep,
                        cornerRadius: min(width, height)/2))
      
    clip()
    translate(by: Point(x: width/2, y: height/2))
    var points: [Point] = [];

    var x1 = random(min: -width / 4, max: width / 4)
    var y1 = random(min: -height / 4, max: height / 4)
    var r1 = width / 10

    var n = 0
    points.append(Point(x: x1, y: y1, z: r1))
    while (n < 5) {
      let m = Int(random(min: 3, max: 7))
      var x2: Float = 0, y2: Float = 0, r2: Float = 0
      var i = 0
      while (i < m) {
        let angle = random(max: 360)
        r2 = random(min: width / 10 / 2, max: width / 3)
        x2 = x1 + cos(angle) * (r1 + r2)
        y2 = y1 + sin(angle) * (r1 + r2)
        
        let a = Point(x: x1, y: y1)
        let b = Point(x: x2, y: y2)
        let distance = a.distance(to: b)
        strokeWeight(distance / 10)
        stroke(with: Color(grey: 0.2))
        line(LineSegment(a: a, b: b))
        points.append(Point(x: x2, y: y2, z: r2))
        i += 1
      }
      x1 = x2
      y1 = y2
      r1 = r2
      n += 1
    }
    points.reverse();
    for p in points {
      strokeWeight(1)
      noStroke()
      let t = Int(random(min: 1, max: Float(colors.count)))
      fill(with: colors[t])
      circle(x: p.x, y: p.y, radius: p.z / 2)
    }
    endClip()
    pop();
  }
  
}
