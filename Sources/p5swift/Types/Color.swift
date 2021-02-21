import CoreGraphics

public struct Color: Equatable {  
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
  
  public func hsba() -> (hue: Float, saturation: Float, brightness: Float, alpha: Float) {
    let val = max(red, green, blue)
    let chroma = val - min(red, green, blue)

    var hue: Float, sat: Float;
    if chroma == 0 {
      // Return early if grayscale.
      hue = 0
      sat = 0
    } else {
      sat = chroma / val;
      if red == val {
        // Magenta to yellow.
        hue = (green - blue) / chroma
      } else if green == val {
        // Yellow to cyan.
        hue = 2 + (blue - red) / chroma
      } else if blue == val {
        // Cyan to magenta.
        hue = 4 + (red - green) / chroma
      } else {
        fatalError()
      }
      
      if hue < 0 {
        // Confine hue to the interval [0, 1).
        hue += 6
      } else if hue >= 6 {
        hue -= 6
      }
    }

    return (hue / 6, sat, val, alpha)

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

public extension Color {
  func withRed(_ newRed: Float) -> Color {
    Color(red: newRed, green: green, blue: blue, alpha: alpha)
  }

  func withGreen(_ newGreen: Float) -> Color {
    Color(red: red, green: newGreen, blue: blue, alpha: alpha)
  }

  func withBlue(_ newBlue: Float) -> Color {
    Color(red: red, green: green, blue: newBlue, alpha: alpha)
  }

  func withAlpha(_ newAlpha: Float) -> Color {
    Color(red: red, green: green, blue: blue, alpha: newAlpha)
  }
  
  func withHue(_ newHue: Float) -> Color {
    let hsba = self.hsba()
    return Color(hue: newHue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
  }

  func withSaturation(_ newSaturation: Float) -> Color {
    let hsba = self.hsba()
    return Color(hue: hsba.hue, saturation: newSaturation, brightness: hsba.brightness, alpha: hsba.alpha)
  }

  func withBrightness(_ newBrightness: Float) -> Color {
    let hsba = self.hsba()
    return Color(hue: hsba.hue, saturation: hsba.saturation, brightness: newBrightness, alpha: hsba.alpha)
  }
}

public extension Color {
  
  // Match colors in format #XXX, e.g. #416.
  private static let hex3 = try! NSRegularExpression(pattern: "^#?([a-f0-9])([a-f0-9])([a-f0-9])$", options: [.caseInsensitive])
  // Match colors in format #XXXX, e.g. #5123.
  private static let hex4 = try! NSRegularExpression(pattern: "^#?([a-f0-9])([a-f0-9])([a-f0-9])([a-f0-9])$", options: [.caseInsensitive])
  // Match colors in format #XXXXXX, e.g. #b4d455.
  private static let hex6 = try! NSRegularExpression(pattern: "^#?([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})$", options: [.caseInsensitive])
  // Match colors in format #XXXXXXXX, e.g. #b4d45535.
  private static let hex8 = try! NSRegularExpression(pattern: "^#?([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})$", options: [.caseInsensitive])
  
  internal static let hexFallbackColor = Color.white

  
  init(hex: String) {
    let range = NSRange(location: 0, length: hex.utf16.count)
    if let match = Color.hex3.firstMatch(in: hex, options: [.anchored], range: range),
       match.numberOfRanges == 4,
       let range1 = Range(match.range(at: 1), in: hex),
       let range2 = Range(match.range(at: 2), in: hex),
       let range3 = Range(match.range(at: 3), in: hex)
    {
      self.init(hexRed: "\(hex[range1])\(hex[range1])",
                green: "\(hex[range2])\(hex[range2])",
                blue: "\(hex[range3])\(hex[range3])",
                alpha: "FF")
    } else if let match = Color.hex4.firstMatch(in: hex, options: [.anchored], range: range),
              match.numberOfRanges == 5,
              let range1 = Range(match.range(at: 1), in: hex),
              let range2 = Range(match.range(at: 2), in: hex),
              let range3 = Range(match.range(at: 3), in: hex),
              let range4 = Range(match.range(at: 4), in: hex)
    {
      self.init(hexRed: "\(hex[range1])\(hex[range1])",
                green: "\(hex[range2])\(hex[range2])",
                blue: "\(hex[range3])\(hex[range3])",
                alpha: "\(hex[range4])\(hex[range4])")
    } else if let match = Color.hex6.firstMatch(in: hex, options: [.anchored], range: range),
              match.numberOfRanges == 4,
              let range1 = Range(match.range(at: 1), in: hex),
              let range2 = Range(match.range(at: 2), in: hex),
              let range3 = Range(match.range(at: 3), in: hex)
    {
      self.init(hexRed: String(hex[range1]),
                green: String(hex[range2]),
                blue: String(hex[range3]),
                alpha: "FF")
      
    } else if let match = Color.hex8.firstMatch(in: hex, options: [.anchored], range: range),
              match.numberOfRanges == 5,
              let range1 = Range(match.range(at: 1), in: hex),
              let range2 = Range(match.range(at: 2), in: hex),
              let range3 = Range(match.range(at: 3), in: hex),
              let range4 = Range(match.range(at: 4), in: hex)
    {
      self.init(hexRed: String(hex[range1]),
                green: String(hex[range2]),
                blue: String(hex[range3]),
                alpha: String(hex[range4]))
    } else {
      debugPrint("Invalid hex color \"\(hex)\"")
      self = Color.hexFallbackColor
    }
  }

  private init(hexRed red: String, green: String, blue: String, alpha: String) {
    if let red = UInt8(red, radix: 16),
       let green = UInt8(green, radix: 16),
       let blue = UInt8(blue, radix: 16),
       let alpha = UInt8(alpha, radix: 16)
    {
      self.init(red: Float(red)/255,
                green: Float(green)/255,
                blue: Float(blue)/255,
                alpha: Float(alpha)/255)
    } else {
      debugPrint("Invalid hex color \"\(red)\(green)\(blue)\(alpha)\"")
      self = Color.hexFallbackColor
    }
  }
}


import UIKit

public extension Color {
  var uiColor: UIColor {
    UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
  }
}
