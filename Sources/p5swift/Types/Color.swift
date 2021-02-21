import CoreGraphics

public struct Color {  
  public var red: Float
  public var green: Float
  public var blue: Float
  public var alpha: Float
  
  public init(red: Float, green: Float, blue: Float, alpha: Float = 1) {
    self.red = red
    self.green = green
    self.blue = blue
    self.alpha = alpha
  }
  
  public init(hue: Float, saturation: Float, brightness: Float, alpha: Float = 1) {
    if (saturation == 0) {
      // greyscale
      self.init(red: brightness, green: brightness, blue: brightness, alpha: alpha)
    } else {
      let hue = hue * 6
      let sector = floor(hue)
      let tint1 = brightness * (1 - saturation)
      let tint2 = brightness * (1 - saturation * (hue - sector))
      let tint3 = brightness * (1 - saturation * (1 + sector - hue))
      let red: Float, green: Float, blue: Float
      switch sector {
      case 1:
        // Yellow to green
        red = tint2
        green = brightness
        blue = tint1
      case 2:
        // Green to cyan
        red =  tint1
        green = tint2
        blue = brightness
      case 3:
        // Cyan to blue
        red = tint1
        green = tint2
        blue = brightness
      case 4:
        // Blue to magenta
        red = tint3
        green = tint1
        blue = brightness
      case 5:
        // Magenta to red
        red = brightness
        green = tint1
        blue = tint2
      default:
        // Red to yellow (sector could be 0 or 6)
        red = brightness
        green = tint3
        blue = tint1
      }
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
  }
}

public extension Color {
  init(grey: Float, alpha: Float = 1) {
    self.init(red: grey, green: grey, blue: grey, alpha: alpha)
  }
}

public extension Color {
  var cgColor: CGColor {
    if #available(iOS 13.0, *) {
      return CGColor(srgbRed: CGFloat(red),
                     green: CGFloat(green),
                     blue: CGFloat(blue),
                     alpha: CGFloat(alpha))
    } else {
      let space = CGColorSpaceCreateDeviceRGB()
      var components = [ CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha) ]
      return CGColor(colorSpace: space, components: &components)!
    }
  }
}

public extension Color {
  static let black = Color(red: 0, green: 0, blue: 0)
  static let white = Color(red: 1, green: 1, blue: 1)
  static let clear = Color(red: 0, green: 0, blue: 0, alpha: 0)
  
  static let red = Color(red: 0.890, green: 0.227, blue: 0.231, alpha: 1.000)
  static let orange = Color(red: 0.973, green: 0.396, blue: 0.024, alpha: 1.000)
  static let yellow = Color(red: 0.976, green: 0.671, blue: 0.031, alpha: 1.000)
  static let green = Color(red: 0.051, green: 0.671, blue: 0.510, alpha: 1.000)
  static let purple = Color(red: 0.180, green: 0.153, blue: 0.635, alpha: 1.000)
  static let grey = Color(red: 0.149, green: 0.149, blue: 0.149, alpha: 1.000)
}
