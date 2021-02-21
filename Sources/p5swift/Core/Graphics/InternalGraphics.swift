import Foundation

protocol InternalGraphics {
  var loop: Bool { get set }

  var rendererView: RendererView { get }

  func internalDraw()
}
