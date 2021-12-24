//
//  Day23.swift
//
//
//  Created by Aaron Sky on 12/23/21.
//

import Algorithms
import Base
import GameplayKit

struct Day23: Day {
    var burrow: [Burrow]

    init(_ input: Input) throws {
        burrow = input.decodeMany(separatedBy: "\n\n")
    }

    func partOne() async -> String {
        let cost = burrow[0].organizeAmphipods()
        return "\(cost)"
    }

    func partTwo() async -> String {
        let cost = burrow[1].organizeAmphipods()
        return "\(cost)"
    }

    class Burrow: RawRepresentable {
        class Amphipod: GKGridGraphNode {
            enum Kind {
                case amber
                case bronze
                case copper
                case desert
            }

            var kind: Kind?

            var movementCost: Int {
                switch kind {
                case .amber:
                    return 1
                case .bronze:
                    return 10
                case .copper:
                    return 100
                case .desert:
                    return 1000
                case .none:
                    return 0
                }
            }

            convenience init(gridPosition: vector_int2, kind: Kind? = nil) {
                self.init(gridPosition: gridPosition)
                self.kind = kind
            }

            override init(gridPosition: vector_int2) {
                kind = nil
                super.init(gridPosition: gridPosition)
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override func cost(to node: GKGraphNode) -> Float {
                Float(movementCost)
            }
        }

        var graph: GKGridGraph<Amphipod>
        var amphipods: [Amphipod]

        var rawValue: String {
            graph.description
        }

        required init?(rawValue: String) {
            enum Token: Character {
                case wall = "#"
                case outside = " "
                case empty = "."
                case amber = "A"
                case bronze = "B"
                case copper = "C"
                case desert = "D"
            }

            let lines = rawValue.split(separator: "\n")
            let width = lines.first!.count
            let height = lines.count

            self.graph = GKGridGraph(fromGridStartingAt: .zero,
                                     width: Int32(width),
                                     height: Int32(height),
                                     diagonalsAllowed: false,
                                     nodeClass: Amphipod.self)

            var nodesToRemove: [GKGridGraphNode] = []
            var amphipods: [Amphipod] = []

            for (y, line) in lines.enumerated() {
                for (x, token) in line
                        .padding(toLength: width, withPad: " ", startingAt: 0)
                        .enumerated() {
                    guard let token = Token(rawValue: token),
                        let node = graph.node(atGridPosition: vector_int2(x: x, y: y)) else {
                        preconditionFailure()
                    }

                    switch token {
                    case .wall, .outside:
                        nodesToRemove.append(node)
                    case .amber:
                        node.kind = .amber
                        amphipods.append(node)
                    case .bronze:
                        node.kind = .bronze
                        amphipods.append(node)
                    case .copper:
                        node.kind = .copper
                        amphipods.append(node)
                    case .desert:
                        node.kind = .desert
                        amphipods.append(node)
                    case .empty:
                        continue
                    }
                }
            }

            graph.remove(nodesToRemove)
            self.amphipods = amphipods
        }

        func organizeAmphipods() -> Int {
            return 0
        }
    }
}
