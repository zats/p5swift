// p5swift

import Foundation
import CoreGraphics

extension LineSegment: PathRepresentable {
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.addLines(between: [ a.cgPoint, b.cgPoint ])
    return path
  }
}
