import Algorithms
import Base
import GameplayKit

struct Day15: Day {
    var input: Input

    init(
        _ input: Input
    ) throws {
        self.input = input
    }

    func partOne() async -> String {
        let path = input.decode { Path(rawValue: $0, repeatFactor: 1) }!
        let leastRisky = path.findLeastRiskyPath()
        return "\(leastRisky)"
    }

    func partTwo() async -> String {
        let path = input.decode { Path(rawValue: $0, repeatFactor: 5) }!
        let leastRisky = path.findLeastRiskyPath()
        return "\(leastRisky)"
    }

    struct Path {
        var graph: GKGridGraph<Node>

        init?(
            rawValue: String,
            repeatFactor: Int = 1
        ) {
            guard repeatFactor > 0 else {
                return nil
            }

            let rows = rawValue.split(separator: "\n")

            guard let width = rows.first?.count else {
                return nil
            }
            let height = rows.count

            graph = GKGridGraph(
                fromGridStartingAt: .zero,
                width: Int32(width * repeatFactor),
                height: Int32(height * repeatFactor),
                diagonalsAllowed: false,
                nodeClass: Node.self
            )

            for (y, row) in rows.enumerated() {
                for (x, element) in row.enumerated() {
                    guard let baseCost = Int(String(element)) else {
                        return nil
                    }

                    guard repeatFactor > 1 else {
                        guard let node = graph.node(atGridPosition: vector_int2(x: x, y: y)) else {
                            return nil
                        }
                        node.cost = baseCost
                        continue
                    }

                    for xOffset in 0..<repeatFactor {
                        for yOffset in 0..<repeatFactor {
                            let position = vector_int2(x: x + (xOffset * width), y: y + (yOffset * height))
                            guard let node = graph.node(atGridPosition: position) else {
                                return nil
                            }

                            let cost = (baseCost + xOffset + yOffset) % 9

                            if cost == 0 {
                                node.cost = 9
                            } else {
                                node.cost = cost
                            }
                        }
                    }
                }
            }
        }

        func findLeastRiskyPath() -> Int {
            guard let source = graph.node(atGridPosition: .zero),
                let target = graph.node(atGridPosition: vector_int2(x: graph.gridWidth - 1, y: graph.gridHeight - 1)),
                let path = graph.findPath(from: source, to: target) as? [Node]
            else {
                return 0
            }

            return path.dropFirst().sum(of: \.cost)
        }

        class Node: GKGridGraphNode {
            var cost: Int

            convenience init(
                gridPosition: vector_int2,
                cost: Int = 0
            ) {
                self.init(gridPosition: gridPosition)
                self.cost = cost
            }

            override init(
                gridPosition: vector_int2
            ) {
                cost = 0
                super.init(gridPosition: gridPosition)
            }

            required init?(
                coder: NSCoder
            ) {
                fatalError("init(coder:) has not been implemented")
            }

            override func cost(to node: GKGraphNode) -> Float {
                Float(cost)
            }
        }
    }
}

extension vector_int2 {
    init(
        x: Int,
        y: Int
    ) {
        self.init(x: Int32(x), y: Int32(y))
    }
}
