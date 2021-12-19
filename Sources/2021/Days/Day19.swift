//
//  Day19.swift
//
//
//  Created by Aaron Sky on 12/19/21.
//

import Algorithms
import Base

struct Day19: Day {
    var scanners: [Scanner]

    init(_ input: Input) throws {
        scanners = input.decodeMany(separatedBy: "\n\n")
    }

    func partOne() async -> String {
        let (allBeacons, _) = findCoincidentalBeacons()
        return "\(allBeacons.count)"
    }

    func partTwo() async -> String {
        let (_, scannerLocations) = findCoincidentalBeacons()
        let max = scannerLocations
            .values
            .combinations(ofCount: 2)
            .map {
                $0[1].manhattanDistance(to: $0[0])
            }
            .max()!
        return "\(max)"
    }

    func findCoincidentalBeacons() -> (allBeacons: Set<Point3>, scannerLocations: [Int: Point3]) {
        guard !scanners.isEmpty else {
            return ([], [:])
        }

        var allBeacons = Set(scanners[0].beacons)
        var scannerLocations: [Int: Point3] = [:]

        var visited = [scanners[0]]

        while let known = visited.popLast() {
            for j in scanners.indices where !scannerLocations.keys.contains(j) {
                let unknown = scanners[j]

                guard let (offset, rotation) = known.comparing(to: unknown) else {
                    continue
                }

                let new = Scanner(beacons: unknown
                                    .beacons
                                    .map {
                    rotation * $0 + offset
                })

                visited.append(new)
                allBeacons.insert(contentsOf: new.beacons)

                scannerLocations[j] = offset
            }
        }

        return (allBeacons, scannerLocations)
    }

    struct Scanner: RawRepresentable {
        var beacons: [Point3]

        var rawValue: String {
            "--- scanner 0 ---\n" + beacons
                .map {
                    "\($0.x),\($0.y),\($0.z)"
                }
                .joined(separator: "\n")
        }

        init(beacons: [Point3]) {
            self.beacons = beacons
        }

        init?(rawValue: String) {
            beacons = rawValue
                .split(separator: "\n")
                .dropFirst()
                .compactMap {
                    let xyz = $0
                        .split(separator: ",")
                        .prefix(3)

                    guard xyz.count == 3,
                          let x = Int(xyz[0]),
                          let y = Int(xyz[1]),
                          let z = Int(xyz[2]) else {
                              return nil
                          }

                    return Point3(x: x, y: y, z: z)
                }
        }

        func comparing(to unknown: Scanner) -> (Point3, RotationMatrix)? {
            for rotation in RotationMatrix.all {
                var counts: [Point3: Int] = [:]

                for x in beacons {
                    for y in unknown.beacons {
                        let offset = x - rotation * y
                        counts[offset, default: 0] += 1

                        if counts[offset] == 12 {
                            return (offset, rotation)
                        }
                    }
                }
            }

            return nil
        }
    }

    struct RotationMatrix {
        let matrix: (
            x: (x: Int, y: Int, z: Int),
            y: (x: Int, y: Int, z: Int),
            z: (x: Int, y: Int, z: Int)
        )

        static var all: [Self] {
            [
                Self(matrix: (( 1,  0,  0), ( 0,  1,  0), ( 0,  0,  1))),
                Self(matrix: (( 1,  0,  0), ( 0, -1,  0), ( 0,  0, -1))),
                Self(matrix: (( 1,  0,  0), ( 0,  0,  1), ( 0, -1,  0))),
                Self(matrix: (( 1,  0,  0), ( 0,  0, -1), ( 0,  1,  0))),
                Self(matrix: ((-1,  0,  0), ( 0,  1,  0), ( 0,  0, -1))),
                Self(matrix: ((-1,  0,  0), ( 0, -1,  0), ( 0,  0,  1))),
                Self(matrix: ((-1,  0,  0), ( 0,  0,  1), ( 0,  1,  0))),
                Self(matrix: ((-1,  0,  0), ( 0,  0, -1), ( 0, -1,  0))),
                Self(matrix: (( 0,  1,  0), ( 1,  0,  0), ( 0,  0, -1))),
                Self(matrix: (( 0,  1,  0), (-1,  0,  0), ( 0,  0,  1))),
                Self(matrix: (( 0,  1,  0), ( 0,  0,  1), ( 1,  0,  0))),
                Self(matrix: (( 0,  1,  0), ( 0,  0, -1), (-1,  0,  0))),
                Self(matrix: (( 0, -1,  0), ( 1,  0,  0), ( 0,  0,  1))),
                Self(matrix: (( 0, -1,  0), (-1,  0,  0), ( 0,  0, -1))),
                Self(matrix: (( 0, -1,  0), ( 0,  0,  1), (-1,  0,  0))),
                Self(matrix: (( 0, -1,  0), ( 0,  0, -1), ( 1,  0,  0))),
                Self(matrix: (( 0,  0,  1), ( 1,  0,  0), ( 0,  1,  0))),
                Self(matrix: (( 0,  0,  1), (-1,  0,  0), ( 0, -1,  0))),
                Self(matrix: (( 0,  0,  1), ( 0,  1,  0), (-1,  0,  0))),
                Self(matrix: (( 0,  0,  1), ( 0, -1,  0), ( 1,  0,  0))),
                Self(matrix: (( 0,  0, -1), ( 1,  0,  0), ( 0, -1,  0))),
                Self(matrix: (( 0,  0, -1), (-1,  0,  0), ( 0,  1,  0))),
                Self(matrix: (( 0,  0, -1), ( 0,  1,  0), ( 1,  0,  0))),
                Self(matrix: (( 0,  0, -1), ( 0, -1,  0), (-1,  0,  0))),
            ]
        }

        static func * (lhs: Self, rhs: Point3) -> Point3 {
            let (x, y, z) = lhs.matrix
            return Point3(
                x: x.x * rhs.x + x.y * rhs.y + x.z * rhs.z,
                y: y.x * rhs.x + y.y * rhs.y + y.z * rhs.z,
                z: z.x * rhs.x + z.y * rhs.y + z.z * rhs.z
            )
        }
    }
}
