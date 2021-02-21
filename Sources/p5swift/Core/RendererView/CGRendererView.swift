import UIKit

class CGRendererView: UIView, RendererView {
  var loop: Bool = true {
    didSet {
      if !oldValue && loop {
        // no loop -> loop
        setNeedsDisplay()
      }
    }
  }

  var frameRate = Defaults.frameRate
  
  var onRenderCallback: RendererViewCallback? = nil
  
  var size: Size
  
  var cgContext: CGContext?
  
  required init(size: Size) {
    self.size = size
    super.init(frame: CGRect(origin: .zero, size: size.cgSize))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func draw(_ rect: CGRect) {
    self.cgContext = UIGraphicsGetCurrentContext()
    onRenderCallback?()
    if loop {
      DispatchQueue.main.async {
        self.setNeedsDisplay()
      }
    }
  }
}
