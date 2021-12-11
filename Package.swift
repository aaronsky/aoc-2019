// swift-tools-version:5.5

import PackageDescription

let allYears = [
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021,
]

func adventTargetName(_ year: Int) -> String {
    "Advent\(year)"
}

func adventTarget(year: Int) -> [Target] {
    [
        .target(
            name: adventTargetName(year),
            dependencies: [
                "Base",
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources/\(year)",
            resources: [
                .copy("Inputs")
            ]),
        .testTarget(
            name: "\(adventTargetName(year))Tests",
            dependencies: [
                .target(name: adventTargetName(year))
            ],
            path: "Tests/\(year)Tests"),
    ]
}

let package = Package(
    name: "advent-of-code",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "aoc",
            targets: ["aoc"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "aoc",
            dependencies: [
                "Base",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ] + allYears.map {
                .target(name: adventTargetName($0))
            }),
        .target(
            name: "Base",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ]),
        .testTarget(
            name: "BaseTests",
            dependencies: ["Base"]),
    ] + allYears.flatMap(adventTarget)
)
