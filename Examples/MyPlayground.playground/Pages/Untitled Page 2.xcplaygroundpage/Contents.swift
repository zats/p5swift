import p5swift
import PlaygroundSupport

public extension Rectangle {
  var center: Point {
    Point(x: x + width * 0.5, y: y + height * 0.5)
  }
  
  var area: Float {
    width * height
  }
}

class Sketch: p5swift.Sketch {
  
  var points: [Point] = []
  var lines: [Line] = []
  
  private func split(_ rect: Rectangle, atX x: Float, y: Float) -> [Rectangle] {
    return [Rectangle(x: rect.x, y: rect.y, width: x, height: y),
      Rectangle(x: rect.x, y: rect.y + y, width: x, height: rect.height - y),
      Rectangle(x: rect.x + x, y: rect.y + y, width: rect.width - x, height: rect.height - y),
      Rectangle(x: rect.x + x, y: rect.y, width: rect.width - x, height: y)
    ]
  }
  
  var rects: [Rectangle] = []
  
  func makeRects(_ rects: [Rectangle]) -> [Rectangle] {
    let minSize = Size(width: 30, height: 30)
    
    if rects.filter({ $0.width > minSize.width && $0.height > minSize.height }).isEmpty {
      return rects
    }

    var result: [Rectangle] = []
    for rect in rects {
      if rect.width < minSize.width || rect.height < minSize.height {
        result.append(rect)
      } else {
        result.append(contentsOf: split(rect,
                                        atX: random(min: 0.4, max: 0.6) * rect.width,
                                        y: random(min: 0.4, max: 0.6) * rect.height))
      }
    }
    if result.count == rects.count {
      return rects
    } else {
      return makeRects(result)
    }
  }
  
  override func setup() {
    rects = makeRects([self.safeFrame.insetBy(dx: 10, dy: 10)])
    for r1 in rects {
      for r2 in rects {
        if r1 == r2 {
          continue
        }
        if r1.center.distance(to: r2.center) < 20 {
          lines.append(Line(a: r1.center, b: r2.center))
        }
      }
    }
    noLoop()
  }
  
  override func draw() {
    background(.cream)
    
    for rect in rects {
      let rect = rect.insetBy(dx: 5, dy: 5)
      circle(center: rect.center, radius: min(rect.width, rect.height) * 0.5)
    }
    
    for l in lines {
      line(l)
    }
    
//    var i = 0
//    while i < points.count - 1 {
//      defer {
//        i += 2
//      }
//      let a = points[i], b = points[i+1]
//      if a.y != b.y { continue }
//      line(Line(a: a, b: b))
//    }
  }
}

let sketch = Sketch(size: Size(width: 600, height: 600))
PlaygroundPage.current.liveView = sketch.view
