import Foundation

public struct Arc {
  public enum Mode {
    case open
  }
  
  public var x: Float
  public var y: Float
  public var radius: Float
  public var start: Float
  public var stop: Float
  public var mode: Mode

  public init(x: Float, y: Float, radius: Float, start: Float, stop: Float, mode: Mode = .open) {
    self.x = x
    self.y = y
    self.radius = radius
    self.start = start
    self.stop = stop
    self.mode = mode
  }
}
