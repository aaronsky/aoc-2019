//
//  Day11.swift
//
//
//  Created by Aaron Sky on 12/9/21.
//

import Algorithms
import Base

struct Day11: Day {
    var matrix: Matrix

    init(_ input: Input) throws {
        matrix = input.decode()!
    }

    func partOne() async -> String {
        var matrix = matrix
        var flashes = 0
        for _ in 1...100 {
            flashes += matrix.step()
        }
        return "\(flashes)"
    }

    func partTwo() async -> String {
        var matrix = matrix
        var step = 0
        for i in 1... {
            step = i
            if matrix.step() == matrix.count {
                break
            }
        }
        return "\(step)"
    }

    struct Matrix: RawRepresentable {
        var octopuses: [Int]
        var width = 10

        var count: Int {
            octopuses.count
        }

        var rawValue: String {
            octopuses
                .chunks(ofCount: width)
                .map {
                    $0
                        .map(String.init)
                        .joined()
                }
                .joined()
        }

        init?(rawValue: String) {
            octopuses = rawValue
                .components(separatedBy: "\n")
                .flatMap {
                    $0.map { Int(String($0))! }
                }
        }

        subscript(_ index: Array<Int>.Index) -> Int {
            octopuses[index]
        }

        subscript(x: Int, y: Int) -> Int? {
            self[(x, y)]
        }

        subscript(position: (x: Int, y: Int)) -> Int? {
            guard position.x >= 0 &&
                    position.x < width &&
                    position.y >= 0 &&
                    position.y < width
            else {
                return nil
            }

            return self[index(of: position)]
        }

        func position(of index: Array<Int>.Index) -> (x: Int, y: Int) {
            (x: index % width, y: index / width)
        }

        func index(of position: (x: Int, y: Int)) -> Array<Int>.Index {
            width * position.y + position.x
        }

        func indicesSurrounding(index: Array<Int>.Index) -> [Array<Int>.Index] {
            indicesSurrounding(position: position(of: index))
        }

        func indicesSurrounding(position: (x: Int, y: Int)) -> [Array<Int>.Index] {
            positionsSurrounding(position: position).map(index(of:))
        }

        func positionsSurrounding(index: Array<Int>.Index) -> [(x: Int, y: Int)] {
            positionsSurrounding(position: position(of: index))
        }

        func positionsSurrounding(position: (x: Int, y: Int)) -> [(x: Int, y: Int)] {
            let (x, y) = position
            let adjacents = [
                (x, y - 1), // N
                (x - 1, y - 1), // NW
                (x - 1, y), // W
                (x - 1, y + 1), // SW
                (x, y + 1), // S
                (x + 1, y + 1), // SE
                (x + 1, y), // E
                (x + 1, y - 1), // NE
            ]

            return adjacents
                .filter { p in
                    p.0 >= 0 &&
                    p.0 < width &&
                    p.1 >= 0 &&
                    p.1 < width
                }
        }

        /// - Returns: number of flashes in step
        mutating func step() -> Int {
            for i in octopuses.indices {
                octopuses[i] += 1
            }

            var flashed: Set<Array<Int>.Index> = []

            for i in octopuses.indices where octopuses[i] > 9 && !flashed.contains(i) {
                flashed.insert(i)

                var nextOctos = [i]

                while let next = nextOctos.popLast() {
                    for adjacent in indicesSurrounding(index: next) {
                        octopuses[adjacent] += 1
                        if octopuses[adjacent] > 9 && !flashed.contains(adjacent) {
                            flashed.insert(adjacent)
                            nextOctos.append(adjacent)
                        }
                    }
                }
            }

            for flashedIndex in flashed {
                octopuses[flashedIndex] = 0
            }

            return flashed.count
        }
    }
}
