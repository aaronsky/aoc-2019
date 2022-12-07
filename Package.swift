// swift-tools-version:5.7

import PackageDescription

let allYears = [
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021,
    2022,
]

// !!!: Update this every year.
let currentYear = 2022

func adventTargetName(_ year: Int) -> String {
    "Advent\(year)"
}

func adventTarget(year: Int, isTesting: Bool = true) -> [Target] {
    var targets: [Target] = [
        .target(
            name: adventTargetName(year),
            dependencies: [
                "Base",
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ],
            path: "Sources/\(year)",
            resources: [
                .copy("Inputs")
            ]
        )
    ]
    if isTesting {
        targets.append(
            .testTarget(
                name: "\(adventTargetName(year))Tests",
                dependencies: [
                    .target(name: adventTargetName(year))
                ],
                path: "Tests/\(year)Tests"
            )
        )
    }
    return targets
}

let package = Package(
    name: "advent-of-code",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "aoc",
            targets: ["aoc"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-async-algorithms.git", .upToNextMajor(from: "0.0.1")),
    ],
    targets: [
        .executableTarget(
            name: "aoc",
            dependencies: [
                "Base",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
                + allYears.map {
                    .target(name: adventTargetName($0))
                }
        ),
        .target(
            name: "Base",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections"),
            ]
        ),
        .testTarget(
            name: "BaseTests",
            dependencies: ["Base"]
        ),
    ]
        + allYears.flatMap {
            adventTarget(year: $0, isTesting: $0 == currentYear)
        }
)
