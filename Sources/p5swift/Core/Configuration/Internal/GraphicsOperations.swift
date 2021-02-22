import Foundation

enum GraphicsOperations {
  case line(Line)
  case rectangle(Rectangle)
  case ellipse(Ellipse)
  case arc(Arc)
  case point(Point)
  
  case clip
  case endClip
  
  case beginShape
  case vertex(Point)
  case curveVertex(Point)
  case endShape(ShapeMode)
  
  case blendMode(BlendMode)
  case background(Color)
  case fill(Color)
  case stroke(Color)
  case strokeWeight(Float)
  case strokeJoin(StrokeJoin)
  case strokeCap(StrokeCap)
  
  case image(Graphics)
  
  case translate(Point)
  case scale(Point)
  case rotate(Float)
  case push
  case pop
}
