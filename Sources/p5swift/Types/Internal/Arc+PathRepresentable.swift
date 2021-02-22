// SnapshotTesting

import Foundation
import CoreGraphics

extension Arc: PathRepresentable {
  var cgPath: CGPath {
    let path = CGMutablePath()
    path.addArc(center: CGPoint(x: CGFloat(x), y: CGFloat(y)),
                radius: CGFloat(radius),
                startAngle: CGFloat(start),
                endAngle: CGFloat(stop),
                clockwise: true)
    return path
  }
}
