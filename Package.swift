// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "p5swift",
  platforms: [
    .iOS(.v13), .tvOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "p5swift",
      targets: ["p5swift"]),
  ],
  dependencies: [
    .package(name: "SnapshotTesting", url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "p5swift",
      dependencies: []),
    .testTarget(
      name: "p5swiftTests",
      dependencies: [ "p5swift", "SnapshotTesting" ],
      exclude: ["__Snapshots__/"])
  ]
)
