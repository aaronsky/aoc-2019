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
            heightMap[p]! + 1
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
                let adjacents = heightMap.positionsSurrounding(position: (x, y))
                for adjacent in adjacents {
                    guard
                        let height = heightMap[adjacent],
                        height < 9,
                        !visited.contains(Pair(adjacent))
                    else {
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
        var heights: [Int]
        var rows: Int // height
        var columns: Int // width

        var rawValue: String {
            heights
                .chunks(ofCount: columns)
                .prefix(rows)
                .map { row in
                    row
                        .map(String.init)
                        .joined()
                }
                .joined(separator: "\n")
        }

        init?(rawValue: String) {
            let rows = rawValue.components(separatedBy: "\n")
            self.rows = rows.count
            self.columns = rows.first!.count
            self.heights = rows
                .flatMap {
                    $0.map { Int(String($0))! }
                }
        }

        subscript(_ index: Array<Int>.Index) -> Int {
            heights[index]
        }

        subscript(x: Int, y: Int) -> Int? {
            self[(x, y)]
        }

        subscript(position: (x: Int, y: Int)) -> Int? {
            guard position.x >= 0 &&
                    position.x < columns &&
                    position.y >= 0 &&
                    position.y < rows
            else {
                return nil
            }

            return self[index(of: position)]
        }

        func position(of index: Array<Int>.Index) -> (x: Int, y: Int) {
            (x: index % columns, y: index / columns)
        }

        func index(of position: (x: Int, y: Int)) -> Array<Int>.Index {
            columns * position.y + position.x
        }

        func findLowPoints() -> [(Int, Int)] {
            var lowPoints: [(Int, Int)] = []
            for (i, height) in heights.enumerated() {
                let (x, y) = position(of: i)

                let isLow = indicesSurrounding(position: (x, y))
                    .allSatisfy { self[$0] > height }

                if isLow {
                    lowPoints.append((x, y))
                }
            }
            return lowPoints
        }

        func indicesSurrounding(index: Array<Int>.Index) -> [Array<Int>.Index] {
            indicesSurrounding(position: position(of: index))
        }

        func indicesSurrounding(position: (x: Int, y: Int)) -> [Array<Int>.Index] {
            positionsSurrounding(position: position)
                .map(index(of:))
        }

        func positionsSurrounding(index: Array<Int>.Index) -> [(x: Int, y: Int)] {
            positionsSurrounding(position: position(of: index))
        }

        func positionsSurrounding(position: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
            let (x, y) = position
            let adjacents = [
                (x, y - 1), // north
                (x, y + 1), // south
                (x - 1, y), // west
                (x + 1, y), // east
            ]

            return adjacents
                .filter { p in
                    p.0 >= 0 &&
                    p.0 < columns &&
                    p.1 >= 0 &&
                    p.1 < rows
                }
        }
    }
}
