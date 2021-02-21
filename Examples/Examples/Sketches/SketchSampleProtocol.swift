// Examples

import Foundation
import p5swift

protocol SketchSample: Sketch {
  static var title: String { get }
  static var author: String { get }
  static var authorUrl: URL { get }
  static var url: URL? { get }
}
