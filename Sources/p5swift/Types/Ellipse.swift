import CoreGraphics

public struct Ellipse {
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

public extension Ellipse {
  init(cgRect: CGRect) {
    self.init(x: Float(cgRect.minX), y: Float(cgRect.minY), width: Float(cgRect.width), height: Float(cgRect.height))
  }
  
  var cgRect: CGRect {
    return CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
  }
}
