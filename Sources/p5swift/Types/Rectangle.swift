import CoreGraphics

public struct Rectangle: Equatable {
  public static let zero = Rectangle(x: 0, y: 0, width: 0, height: 0)
  
  public var x: Float
  public var y: Float
  public var width: Float
  public var height: Float
  
  public var cornerWidth: Float
  public var cornerHeight: Float
  
  public var hasRoundedCorners: Bool {
    cornerWidth > 0 || cornerHeight > 0
  }

  public init(x: Float, y: Float, width: Float, height: Float, cornerRadius: Float = 0) {
    self.init(x: x, y: y, width: width, height: height, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
  }
  
  public init(x: Float,
              y: Float,
              width: Float,
              height: Float,
              cornerWidth: Float,
              cornerHeight: Float) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.cornerWidth = cornerWidth
    self.cornerHeight = cornerHeight

  }
}

public extension Rectangle {
  init(cgRect: CGRect) {
    self.init(x: Float(cgRect.minX), y: Float(cgRect.minY), width: Float(cgRect.width), height: Float(cgRect.height))
  }
  
  var cgRect: CGRect {
    return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
  }
}

public extension Rectangle {
  init(origin: Point, size: Size) {
    self.init(x: origin.x, y: origin.y, width: size.width, height: size.height)
  }
  
  var origin: Point {
    Point(x: x, y: y)
  }
  
  var size: Size {
    Size(width: width, height: height)
  }
}

public extension Rectangle {
  var topLeft: Point {
    Point(x: x, y: y)
  }
  
  var topRight: Point {
    Point(x: maxX, y: y)
  }
  
  var bottomRight: Point {
    Point(x: maxX, y: maxY)
  }

  var bottomLeft: Point {
    Point(x: x, y: maxY)
  }
  
  var maxY: Float {
    y + height
  }
  
  var maxX: Float {
    x + width
  }
}

public extension Rectangle {
  func insetBy(dx: Float, dy: Float) -> Rectangle {
    return Rectangle(x: x + dx,
                     y: y + dy,
                     width: width - dx * 2,
                     height: height - dy * 2)
  }
}

public extension Rectangle {
  enum IterationOrder {
    case xFirst, yFirst
  }
  
  func iterate(by step: Float, order: IterationOrder = .yFirst, iterator: (Point) -> Void) {
    iterate(by: Point(x: step, y: step), order: order, iterator: iterator)
  }

  func iterate(by step: Point, order: IterationOrder = .yFirst, iterator: (Point) -> Void) {
    switch order {
    case .xFirst:
      for x in stride(from: self.x, through: maxX, by: step.x) {
        for y in stride(from: self.y, through: maxY, by: step.y) {
          iterator(Point(x: x, y: y))
        }
      }
    case .yFirst:
      for y in stride(from: self.y, through: maxY, by: step.y) {
        for x in stride(from: self.x, through: maxX, by: step.x) {
          iterator(Point(x: x, y: y))
        }
      }
    }
  }
}

public extension Rectangle {
  enum Edge: CaseIterable {
    case minX, minY, maxX, maxY
  }
  
  func split(at: Float, edge: Edge) -> (slice: Rectangle, remainder: Rectangle) {
    switch edge {
    case .minX:
      return (slice: Rectangle(x: x, y: y, width: at, height: height),
              remainder: Rectangle(x: at, y: y, width: width - at, height: height))
    case .minY:
      return (slice: Rectangle(x: x, y: y, width: width, height: at),
              remainder: Rectangle(x: x, y: at, width: width, height: height - at))
    case .maxX:
      return (slice: Rectangle(x: x + width - at, y: y, width: at, height: height),
              remainder: Rectangle(x: x, y: y, width: width - at, height: height))
    case .maxY:
      return (slice: Rectangle(x: x, y: y + height - at, width: width, height: at),
              remainder: Rectangle(x: x, y: y, width: width, height: height - at))
    }
  }
  
  func line(at edge: Edge) -> Line {
    switch edge {
    case .minX:
      return Line(a: topLeft, b: bottomLeft)
    case .minY:
      return Line(a: topLeft, b: topRight)
    case .maxX:
      return Line(a: bottomRight, b: topRight)
    case .maxY:
      return Line(a: bottomLeft, b: bottomRight)
    }
  }
  
  func intersects(_ another: Rectangle) -> Bool {
    return !((x >= another.maxX || maxX <= another.x)
              || (y >= another.maxY || maxY <= another.y))
  }
  
  func union(with other: Rectangle) -> Rectangle {
    Rectangle(x: min(x, other.x),
              y: min(y, other.y),
              width: max(maxX, other.maxX) - min(x, other.x),
              height: max(maxY, other.maxY) - min(y, other.y))
  }
}

