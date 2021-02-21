// p5swift

import CoreGraphics

extension BlendMode {
  var cgBlendMode: CGBlendMode {
    switch self {
    case .blend:
      return .normal
    case .add:
      return .screen
    case .darkest:
      return .darken
    case .lightest:
      return .lighten
    case .difference:
      return .difference
    case .exclusion:
      return .exclusion
    case .multiply:
      return .multiply
    case .screen:
      return .screen
    case .replace:
      fatalError("Not implemented yet")
    case .remove:
      fatalError("Not implemented yet")
    case .overlay:
      return .overlay
    case .hardLight:
      return .hardLight
    case .softLiht:
      return .softLight
    case .dodge:
      return .colorDodge
    case .burn:
      return .colorBurn
    case .subtract:
      fatalError("Not implemented yet")
    }
  }
}
