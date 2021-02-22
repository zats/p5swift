import CoreGraphics

public struct Rectangle {
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
