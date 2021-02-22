// p5swift

import CoreGraphics

extension ShapeMode {
  func finalizeShape(in path: CGMutablePath) {
    switch self {
    case .open:
      // no-op
      break
    case .close:
      path.closeSubpath()
    }
  }
}
