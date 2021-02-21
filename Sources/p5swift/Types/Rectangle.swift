import CoreGraphics

public struct Rectangle {
  public var x: Float
  public var y: Float
  public var width: Float
  public var height: Float
  
  public init(x: Float, y: Float, width: Float, height: Float) {
    self.x = x
    self.y = y
    self.width = width
    self.height = height
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
