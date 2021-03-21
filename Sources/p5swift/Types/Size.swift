import Foundation
import CoreGraphics

public struct Size {
  public var width: Float, height: Float

  public init(width: Float, height: Float) {
    self.width = width
    self.height = height
  }
}

public extension Size {
  init(cgSize: CGSize) {
    self.init(width: Float(cgSize.width), height: Float(cgSize.height))
  }
  
  var cgSize: CGSize {
    CGSize(width: CGFloat(width), height: CGFloat(height))
  }
}

public extension Size {
  static func * (lhs: Size, rhs: Float) -> Size {
    Size(width: lhs.width * rhs, height: lhs.height * rhs)
  }
}
