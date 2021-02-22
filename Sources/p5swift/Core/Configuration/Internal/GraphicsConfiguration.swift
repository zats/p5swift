// p5swift

import CoreGraphics

struct GraphicsConfiguration {
  var stroke: Color = .black
  var fill: Color = .white
  var background: Color = .grey
  var strokeCap: StrokeCap = .round
  var strokeJoin: StrokeJoin = .miter
  var strokeWeight: Float = 1
  var lastPath: CGPath?
  var curveTightness: Float = 0  
  lazy var ongoingPath = OngoingPath(curveTightness: curveTightness)
}

struct OngoingPath {
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
  
  private var finalized = false
  private var endPathMode: ShapeMode = .open
  let curveTightness: Float
  
  init(curveTightness: Float) {
    self.curveTightness = curveTightness
  }
  
  var isEmpty: Bool {
    ongoingPath.isEmpty
  }

  private var ongoingPath: [PathElement] = []

  mutating func addCurveVertex(_ point: Point) {
    assert(!finalized)
    ongoingPath.append(.curveVertex(point))
  }

  mutating func addVertex(_ point: Point) {
    assert(!finalized)
    ongoingPath.append(.vertex(point))
  }

  mutating func endPath(_ mode: ShapeMode) {
    self.finalized = true
    self.endPathMode = mode
  }
}


extension OngoingPath: PathRepresentable {
  var cgPath: CGPath {
    guard !isEmpty else {
      return CGMutablePath()
    }
    
    var isCurve = true
    for (i, _) in ongoingPath.dropLast().enumerated() {
      switch (ongoingPath[i], ongoingPath[i + 1]) {
      case (.vertex, .vertex):
        isCurve = false
      case (.curveVertex, .curveVertex):
        isCurve = true
      default:
        debugPrint("Mix of curve vertices and regular vertices")
        return CGMutablePath()
      }
    }
    
    let cgPath = CGMutablePath()
    if isCurve && ongoingPath.count > 3 {
      let s = 1 - curveTightness
      cgPath.move(to: ongoingPath[0].point.cgPoint)
      for i in 1..<ongoingPath.count - 2 {
        let p0 = ongoingPath[i].point
        let cp1 = Point(x: p0.x + (s * ongoingPath[i + 1].point.x - s * ongoingPath[i - 1].point.x) / 6,
                        y: p0.y + (s * ongoingPath[i + 1].point.y - s * ongoingPath[i - 1].point.y) / 6)
        let cp2 = Point(x: ongoingPath[i + 1].point.x + (s * ongoingPath[i].point.x - s * ongoingPath[i + 2].point.x) / 6,
                        y: ongoingPath[i + 1].point.y + (s * ongoingPath[i].point.y - s * ongoingPath[i + 2].point.y) / 6)
        let p = Point(x: ongoingPath[i + 1].point.x,
                      y: ongoingPath[i + 1].point.y);
        cgPath.addCurve(to: p.cgPoint,
                      control1: cp1.cgPoint,
                      control2: cp2.cgPoint)
      }
      endPathMode.finalizeShape(in: cgPath)
    } else {
      cgPath.addLines(between: ongoingPath.map { $0.point.cgPoint })
      endPathMode.finalizeShape(in: cgPath)
    }
    return cgPath
  }
}
