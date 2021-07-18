// Examples

import Foundation
import p5swift
import SceneKit

class GreebleSketch: Sketch, SketchSample {
  static let title = "My Sketch"
  static let author = "okazz"
  static let authorUrl = URL(string: "https://twitter.com/okazz_")!
  static let url = URL(string: "https://openprocessing.org/sketch/1085350/")
  
  var shapes: [Rectangle] = []
  
  override func setup() {
    var allShapes: [[Rectangle]] = []
    var currentShapes: [Rectangle]
    
    currentShapes = []
    for _ in 0...10 {
      let dimensionRange: ClosedRange<Float> = 0.08...0.1
      let dimension = (size.width * dimensionRange.random() + size.height * dimensionRange.random()) / 2
      if let rect = randomRect(size: Size(width: dimension * random(min: 0.8, max: 1.2), height: dimension * random(min: 0.8, max: 1.2)), around: .zero) {
        shapes.append(rect)
        currentShapes.append(rect)
      }
    }
    allShapes.append(currentShapes)
    
    
    currentShapes = []
    for subCount in 0...100 {
      let dimensionRange: ClosedRange<Float> = 0.01...0.02
      let dimension = (size.width * dimensionRange.random() + size.height * dimensionRange.random()) / 2
      if let rect = randomRect(size: Size(width: dimension * random(min: 0.8, max: 1.2), height: dimension * random(min: 0.8, max: 1.2)), around: .zero) {
      shapes.append(rect)
        currentShapes.append(rect)
      }
    }
    allShapes.append(currentShapes)

    currentShapes = []
    for _ in 0...1000 {
      let dimensionRange: ClosedRange<Float> = 0.001...0.005
      let dimension = (size.width * dimensionRange.random() + size.height * dimensionRange.random()) / 2
      if let rect = randomRect(size: Size(width: dimension * random(min: 0.8, max: 1.2), height: dimension * random(min: 0.8, max: 1.2)), around: .zero) {
        shapes.append(rect)
        currentShapes.append(rect)
      }
    }
    allShapes.append(currentShapes)


    let scene = SCNScene()
    var heightRange: ClosedRange<Float> = 100...500
    for shapes in allShapes {
      for shape in shapes {
        let height = CGFloat(heightRange.random())
        let sh = SCNShape(path: UIBezierPath(rect: shape.cgRect), extrusionDepth: height)
        let no = SCNNode(geometry: sh)
        no.position = SCNVector3(0, 0, height * 0.5)
        scene.rootNode.addChildNode(no)
      }
      heightRange = sqrt(heightRange.lowerBound)...sqrt(heightRange.upperBound)
    }
    
    
    let sceneUrl = FileManager.default.temporaryDirectory.appendingPathComponent("scene.stl")
    scene.write(to: sceneUrl, options: nil, delegate: nil, progressHandler: nil)
    print(sceneUrl.relativePath)
  }
  
  private func randomRect(size rectSize: Size, around: Point) -> Rectangle?  {
    for _ in 0...10000 {
      let rect = Rectangle(x: random(max: size.width - rectSize.width),
                           y: random(max: size.height - rectSize.height),
                           width: rectSize.width,
                           height: rectSize.height)
      var goodToGo = true
      for existingRect in shapes {
        if existingRect.intersects(rect) {
          goodToGo = false
          break
        }
      }
      if goodToGo {
        return rect
      }
    }
    return nil
  }

  override func draw() {
    background(.red)
    for rect in shapes {
      rectangle(rect)
      stroke(with: .black)
    }
  }
}
