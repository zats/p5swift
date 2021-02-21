import UIKit

public protocol Graphics {
  var size: Size { get }
  var frameCount: Int { get }
  var view: UIView { get }

  func rectangle(_ rectangle: Rectangle)
  func ellipse(_ ellipse: Ellipse)
  func arc(_ arc: Arc)
  func point(_ point: Point)
  
  func beginShape()
  func vertex(_ point: Point)
  func curveVertex(_ point: Point)
  func endShape(_ mode: ShapeMode)
  
  func blendMode(_ mode: BlendMode)
  func background(_ color: Color)
  func fill(with color: Color)
  func stroke(with color: Color)
  func strokeCap(_ strokeCap: StrokeCap)
  func strokeJoin(_ strokeCap: StrokeJoin)
  func strokeWeight(_ weight: Float)
  
  func translate(by point: Point)
  func scale(by point: Point)
  func rotate(by angle: Float)
  func push()
  func pop()
  
  func image(_ graphics: Graphics)
}

public extension Graphics {
  func noStroke() {
    stroke(with: .clear)
  }
  
  func noFill() {
    fill(with: .clear)
  }
}

public extension Graphics {
  func circle(x: Float, y: Float, radius: Float) {
    ellipse(Ellipse(x: x, y: y, width: radius * 2, height: radius * 2))
  }
}
