// p5swift

import CoreGraphics

extension StrokeJoin {
    var cgLineJoin: CGLineJoin {
        switch self {
        case .miter:
            return .miter
        case .bevel:
            return .bevel
        case .round:
            return .round
        }
    }
}
