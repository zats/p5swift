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
    let path = arc.cgPath
    configuration.lastPath = path
    if configuration.fill.alpha > 0 {
      configuration.applyFill(to: context)
      context.addPath(path)
      context.fillPath()
    }
    if configuration.stroke.alpha > 0 {
      configuration.applyStroke(to: context)
      context.addPath(path)
      context.strokePath()
    }
    
  }
  
  func internalDraw() {
    let cgContext = cgRendererView.cgContext!
    for operation in operations {
      switch operation {
      case .clip:
        if let lastPath = configuration.lastPath {
          cgContext.addPath(lastPath)
          cgContext.clip()
          configuration.lastPath = nil
        } else {
          debugPrint("No path to clip")
        }
      case .endClip:
        cgContext.resetClip()
      
      case let .line(line):
        configuration.strokeOrFill(context: cgContext, path: line.cgPath)
      case let .rectangle(rect):
        configuration.strokeOrFill(context: cgContext, path: rect.cgPath)
      case let .ellipse(ellipse):
        configuration.strokeOrFill(context: cgContext, path: ellipse.cgPath)
      case let .arc(arc):
        draw(arc, in: cgContext)
      case let .point(point):
        let path = CGMutablePath()
        path.addEllipse(in: CGRect(x: CGFloat(point.x), y: CGFloat(point.y), width: 0, height: 0))
        configuration.strokeOrFill(context: cgContext, path: path)
        
      case .beginShape:
        if !configuration.ongoingPath.isEmpty {
          configuration.ongoingPath = OngoingPath(curveTightness: configuration.curveTightness)
          debugPrint("beginShape called while another path was started")
        }
      case let .vertex(point):
        configuration.ongoingPath.addVertex(point)
      case let .curveVertex(point):
        configuration.ongoingPath.addCurveVertex(point)
      case let .endShape(mode):
        configuration.ongoingPath.endPath(mode)
        configuration.strokeOrFill(context: cgContext, path: configuration.ongoingPath.cgPath)
        configuration.ongoingPath = OngoingPath(curveTightness: configuration.curveTightness)

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
  
  func blendMode(_ mode: BlendMode) {
    operations.append(.blendMode(mode))
  }
  
  func clip() {
    operations.append(.clip)
  }
  
  func endClip() {
    operations.append(.endClip)
  }
  
  func line(_ line: Line) {
    operations.append(.line(line))
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
