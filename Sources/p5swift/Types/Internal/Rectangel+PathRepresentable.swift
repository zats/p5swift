// p5swift

import Foundation
import CoreGraphics

extension Rectangle: PathRepresentable {
  var cgPath: CGPath {
    let path = CGMutablePath()
    if hasRoundedCorners {
      let rect = cgRect
      path.addRoundedRect(in: cgRect,
                          cornerWidth: min(CGFloat(cornerWidth), rect.width / 2),
                          cornerHeight: min(CGFloat(cornerHeight), rect.height / 2))
    } else {
      path.addRect(cgRect)
    }
    return path
  }
}
