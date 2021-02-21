import CoreGraphics
import UIKit

class CGGraphics: Graphics, InternalGraphics {
  var view: UIView {
    cgRendererView
  }
      
  var size: Size
  
  var loop: Bool {
    set {
      rendererView.loop = newValue
    }
    get {
      rendererView.loop
    }
  }
  
  private (set) var frameCount: Int = 1
  
  private var configuration = GraphicsConfiguration()
  
  var operations: [GraphicsOperations] = []
  
  private var curveTightness: Float = 0
  
  var rendererView: RendererView {
    cgRendererView
  }
  
  private var cgRendererView: CGRendererView
  
  required init(size: Size) {
    self.size = size
    self.cgRendererView = CGRendererView(size: size)
    self.cgRendererView.onRenderCallback = internalDraw
  }
    
  private func draw(_ arc: Arc, in context: CGContext) {
    let center = CGPoint(x: CGFloat(arc.x), y: CGFloat(arc.y))
    if configuration.fill.alpha > 0 {
      configuration.applyFill(to: context)
      context.addArc(center: center,
                     radius: CGFloat(arc.radius),
                     startAngle: CGFloat(arc.start),
                     endAngle: CGFloat(arc.stop),
                     clockwise: true)
      context.fillPath()
    }
    if configuration.stroke.alpha > 0 {
      configuration.applyStroke(to: context)
      context.addArc(center: center,
                     radius: CGFloat(arc.radius),
                     startAngle: CGFloat(arc.start), endAngle: CGFloat(arc.stop),
                     clockwise: true)
      context.strokePath()
    }
    
  }
  private enum PathElement {
    case vertex(Point)
    case curveVertex(Point)
    
    var point: Point {
      switch self {
      case let .vertex(point):
        return point
      case let .curveVertex(point):
        return point
      }
    }
  }
  private var ongoingPath: [PathElement] = []
  
  func internalDraw() {
    let cgContext = cgRendererView.cgContext!
    for operation in operations {
      switch operation {
      case let .rectangle(rect):
        configuration.strokeOrFill(context: cgContext) {
          cgContext.addRect(rect.cgRect)
        }
      case let .ellipse(ellipse):
        configuration.strokeOrFill(context: cgContext) {
          cgContext.addEllipse(in: ellipse.cgRect)
        }
      case let .arc(arc):
        draw(arc, in: cgContext)
      case let .point(point):
        configuration.strokeOrFill(context: cgContext) {
          cgContext.addEllipse(in: CGRect(x: CGFloat(point.x), y: CGFloat(point.y), width: 0, height: 0))
        }
        
      case .beginShape:
        assert(ongoingPath.isEmpty)
        ongoingPath = []
      case let .vertex(point):
        ongoingPath.append(.vertex(point))
      case let .curveVertex(point):
        ongoingPath.append(.curveVertex(point))
      case let .endShape(mode):
        drawPath(ongoingPath, in: cgContext, shapeMode: mode)
        ongoingPath = []
      case let .blendMode(mode):
        cgContext.setBlendMode(mode.cgBlendMode)
      case let .fill(color):
        configuration.fill = color
      case let .stroke(color):
        configuration.stroke = color
      case let .background(color):
        configuration.background = color
        cgContext.setFillColor(color.cgColor)
        cgContext.fill(CGRect(origin: .zero, size: size.cgSize))
      case let .strokeWeight(weight):
        configuration.strokeWeight = weight
      case let .strokeCap(cap):
        configuration.strokeCap = cap
      case let .strokeJoin(join):
        configuration.strokeJoin = join
        
      case let .image(graphics):
        graphics.view.layer.draw(in: cgContext)
        
      case .push:
        cgContext.saveGState()
      case .pop:
        cgContext.restoreGState()
      case let .translate(point):
        cgContext.translateBy(x: CGFloat(point.x), y: CGFloat(point.y))
      case let .scale(point):
        cgContext.scaleBy(x: CGFloat(point.x), y: CGFloat(point.y))
      case let .rotate(angle):
        cgContext.rotate(by: CGFloat(angle))
      }
    }
    
    operations = []
    
    frameCount += 1
  }
  
  private func drawPath(_ path: [PathElement], in context: CGContext, shapeMode: ShapeMode) {
    if path.isEmpty {
      return
    }
    var isCurve = true
    for (i, _) in path.dropLast().enumerated() {
      switch (path[i], path[i + 1]) {
      case (.vertex, .vertex):
        isCurve = false
      case (.curveVertex, .curveVertex):
        isCurve = true
      default:
        assertionFailure("Mix of curve vertices and regular vertices")
        return
      }
    }
    configuration.strokeOrFill(context: context) {
      if isCurve && path.count > 3 {
        let s = 1 - curveTightness
        context.beginPath()
        context.move(to: path[0].point.cgPoint)
        for i in 1..<path.count - 2 {
          let p0 = path[i].point
          let cp1 = Point(x: p0.x + (s * path[i + 1].point.x - s * path[i - 1].point.x) / 6,
                          y: p0.y + (s * path[i + 1].point.y - s * path[i - 1].point.y) / 6)
          let cp2 = Point(x: path[i + 1].point.x + (s * path[i].point.x - s * path[i + 2].point.x) / 6,
                          y: path[i + 1].point.y + (s * path[i].point.y - s * path[i + 2].point.y) / 6)
          let p = Point(x: path[i + 1].point.x,
                        y: path[i + 1].point.y);
          context.addCurve(to: p.cgPoint,
                           control1: cp1.cgPoint,
                           control2: cp2.cgPoint)
          shapeMode.finalizeShape(in: context)
        }
      } else {
        context.beginPath()
        context.addLines(between: path.map { $0.point.cgPoint })
        shapeMode.finalizeShape(in: context)
      }
      // TODO: add bezier vertex handling
    }

  }
  
  func blendMode(_ mode: BlendMode) {
    operations.append(.blendMode(mode))
  }
  
  func rectangle(_ rect: Rectangle) {
    operations.append(.rectangle(rect))
  }
  
  func ellipse(_ ellipse: Ellipse) {
    operations.append(.ellipse(ellipse))
  }
  
  func arc(_ arc: Arc) {
    operations.append(.arc(arc))
  }
  
  func point(_ point: Point) {
    operations.append(.point(point))
  }
  
  func beginShape() {
    operations.append(.beginShape)
  }
  
  func vertex(_ point: Point) {
    operations.append(.vertex(point))
  }
  
  func curveVertex(_ point: Point) {
    operations.append(.curveVertex(point))
  }
  
  func endShape(_ mode: ShapeMode = .open) {
    operations.append(.endShape(mode))
  }
  
  func background(_ color: Color) {
    operations.append(.background(color))
  }
  
  func fill(with color: Color) {
    operations.append(.fill(color))
  }
  
  func stroke(with color: Color) {
    operations.append(.stroke(color))
  }
  
  func strokeCap(_ strokeCap: StrokeCap) {
    operations.append(.strokeCap(strokeCap))
  }
  
  func strokeJoin(_ strokeCap: StrokeJoin) {
    operations.append(.strokeJoin(strokeCap))
  }
  
  func strokeWeight(_ weight: Float) {
    operations.append(.strokeWeight(weight))
  }
  
  func image(_ graphics: Graphics) {
    operations.append(.image(graphics))
  }
  
  func push() {
    operations.append(.push)
  }
  
  func pop() {
    operations.append(.pop)
  }
  
  func translate(by point: Point) {
    operations.append(.translate(point))
  }
  
  func scale(by point: Point) {
    operations.append(.scale(point))
  }
  
  func rotate(by angle: Float) {
    operations.append(.rotate(angle))
  }
}
