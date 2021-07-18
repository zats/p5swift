import p5swift

class Joint {
  var a: Point
  var length: Float
  var angle: Float
  var runningAngle: Float
  var b: Point {
    Point(angle: angle, radius: length, origin: a)
  }
  
  var parent: Joint?
  var child: Joint? {
    didSet {
      child?.parent = self
    }
  }
  
  init(a: Point, length: Float, angle: Float) {
    self.a = a
    self.length = length
    self.angle = angle
    self.runningAngle = angle
  }
  
  func update() {
    child?.runningAngle = runningAngle
  }
}

class Sketch: p5swift.Sketch {
  var root: Joint = Joint(a: .zero, length: 30, angle: 0)
  
  override func setup() {
    var current = root
    for _ in 0...10 {
      let new = Joint(a: current.b, length: 30, angle: .pi/4)
      current.child = new
      current = new
    }
  }
  
  override func draw() {
    background(.white)
    translate(by: Point(x: width * 0.5, y: height * 0.5))
    var current = root
    repeat {
      line(Line(a: current.a, b: current.b))
      if let next = current.child {
        current = next
      } else {
        break
      }
    } while true
  }
}

import PlaygroundSupport
let sketch = Sketch(size: Size(width: 600, height: 600))
PlaygroundPage.current.liveView = sketch.view
print("Done")
