// p5swift

import Foundation
import CoreGraphics

extension Ellipse: PathRepresentable {
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.addEllipse(in: cgRect)
    return path
  }
}
