import UIKit

protocol RendererView: UIView {
  var frameRate: Int { get set }
  
  var loop: Bool { get set }
  
  typealias RendererViewCallback = () -> Void
  var onRenderCallback: RendererViewCallback? { get set }
  
  var size: Size { get set }
  
  init(size: Size)
}
