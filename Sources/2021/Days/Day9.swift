//
//  Day9.swift
//
//
//  Created by Aaron Sky on 12/8/21.
//

import Algorithms
import Base

struct Day9: Day {
    var heightMap: HeightMap

    init(_ input: Input) throws {
        heightMap = input.decode()!
    }

    func partOne() async -> String {
        let lowPoints = heightMap.findLowPoints()
        let riskLevel = lowPoints.sum { p in
            heightMap.heights[p] + 1
        }

        return "\(riskLevel)"
    }

    func partTwo() async -> String {
        let lowPoints = heightMap.findLowPoints()
        var basinSizes: [Int] = []

        for lowPoint in lowPoints {
            var visited: Set<Pair<Int, Int>> = []
            var next = [lowPoint]
            while let (x, y) = next.popLast() {
                visited.insert(Pair(x, y))
                let adjacents = heightMap.heights.positionsSurrounding(position: (x, y))
                for adjacent in adjacents {
                    let height = heightMap.heights[adjacent]
                    guard height < 9 && !visited.contains(Pair(adjacent)) else {
                        continue
                    }

                    next.append(adjacent)
                }
            }

            basinSizes.append(visited.count)
        }

        return "\(basinSizes.max(count: 3).product)"
    }

    struct HeightMap: RawRepresentable {
        var heights: Matrix<Int>

        var rawValue: String {
            heights
                .chunks(ofCount: heights.rowWidth)
                .prefix(heights.rows)
                .map { row in
                    row
                        .map(String.init)
                        .joined()
                }
                .joined(separator: "\n")
        }

        init?(rawValue: String) {
            let rows = rawValue.components(separatedBy: "\n")
            self.heights = Matrix(rows.flatMap { $0.map { Int(String($0))! } },
                                  rowWidth: rows.first!.count,
                                  rows: rows.count)
        }

        func findLowPoints() -> [(Int, Int)] {
            var lowPoints: [(Int, Int)] = []
            for (i, height) in heights.enumerated() {
                let (x, y) = heights.position(of: i)

                let isLow = heights.indicesSurrounding(position: (x, y))
                    .allSatisfy { heights[$0] > height }

                if isLow {
                    lowPoints.append((x, y))
                }
            }
            return lowPoints
        }
    }
}
