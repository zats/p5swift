// p5swift

import CoreGraphics

extension GraphicsConfiguration {
  mutating func strokeOrFill(context: CGContext, path: CGPath) {
    self.lastPath = path
    strokeOrFill(context: context) {
      context.addPath(path)
    }
  }
  
  func strokeOrFill(context: CGContext, block: () -> Void) {
    if fill.alpha > 0 {
      applyFill(to: context)
      block()
      context.fillPath()
    }
    
    if stroke.alpha > 0 {
      applyStroke(to: context)
      block()
      context.strokePath()
    }
  }
  
  func applyFill(to context: CGContext) {
    context.setFillColor(fill.cgColor)
  }
  
  func applyStroke(to context: CGContext) {
    context.setLineWidth(CGFloat(strokeWeight))
    context.setLineCap(strokeCap.cgLineCap)
    context.setLineJoin(strokeJoin.cgLineJoin)
    context.setStrokeColor(stroke.cgColor)
  }
}

