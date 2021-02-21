// p5swift

import CoreGraphics

extension StrokeCap {
    var cgLineCap: CGLineCap {
        switch self {
        case .round:
            return .round
        case .square:
            return .square
        case .butt:
            return .butt
        }
    }
}
