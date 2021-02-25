// p5swift-sample

import Foundation

public func map(value: Float, start1: Float, stop1: Float, start2: Float, stop2: Float, withinBounds: Bool = false) -> Float {
  let newValue = (value - start1) / (stop1 - start1) * (stop2 - start2) + start2
  if !withinBounds {
    return newValue
  }
  if start2 < stop2 {
    return constrain(value: newValue, min: start2, max: stop2)
  } else {
    return constrain(value: newValue, min: stop2, max: start2)
  }

}

public func constrain(value: Float, min: Float, max: Float) -> Float {
  return Swift.max(Swift.min(value, max), min)
}

public func map(value: Float, from: Range<Float>, to: Range<Float>, withinBounds: Bool = false) -> Float {
  let newValue = (value - from.lowerBound) / (from.upperBound - from.lowerBound) * (to.upperBound - to.lowerBound) + to.lowerBound
  if !withinBounds {
    return newValue
  }
  return constrain(value: newValue, in: to)
}

public func constrain(value: Float, in range: Range<Float>) -> Float {
  return Swift.max(Swift.min(value, range.upperBound), range.lowerBound)
}

public func lerp(start: Point, stop: Point, amount: Float) -> Point {
  Point(x: lerp(start: start.x, stop: stop.x, amount: amount),
        y: lerp(start: start.y, stop: stop.y, amount: amount),
        z: lerp(start: start.z, stop: stop.z, amount: amount))
}

public func lerp(start: Float, stop: Float, amount: Float) -> Float {
  (stop - start) * amount + start
}
