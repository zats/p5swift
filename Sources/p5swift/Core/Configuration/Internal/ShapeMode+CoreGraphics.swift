// p5swift

import CoreGraphics

extension ShapeMode {
  func finalizeShape(in context: CGContext) {
    switch self {
    case .open:
      // no-op
      break
    case .close:
      context.closePath()
    }
  }
}
