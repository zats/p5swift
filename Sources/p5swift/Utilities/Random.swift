import Foundation
import GameKit

private var randomSource = GKARC4RandomSource()

public func random() -> Float {
  random(max: 1)
}

public func random(max: Float) -> Float {
  random(min: 0, max: max)
}

public func random(min: Float, max: Float) -> Float {
  randomSource.nextUniform() * (max - min) + min
}

public func randomSeed(_ seed: Int) {
  var seed = seed
  randomSource.seed = Data(bytes: &seed, count: MemoryLayout.size(ofValue: seed))
}

private let gaussianDistribution = GKGaussianDistribution(randomSource: GKRandomSource.sharedRandom(), lowestValue: 0, highestValue: 1000000)
public func randomGaussian(mean: Float = 0, standardDeviation: Float) -> Float {
  let halfSD = standardDeviation * 0.5
  return map(value: gaussianDistribution.nextUniform(),
      start1: 0,
      stop1: 1,
      start2: mean - halfSD,
      stop2: mean + halfSD)
}

private let perlinNoiseSource = GKPerlinNoiseSource()
private let perlinNoise = GKNoise(perlinNoiseSource)
public func noise(x: Float, y: Float = 0, z: Float = 0) -> Float {
  perlinNoise.value(atPosition: vector_float2(x: x, y: y))
}

public func noiseSeed(_ seed: Int) {
  perlinNoiseSource.seed = Int32(seed)
}
