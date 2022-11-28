import Algorithms
import Base
import Collections

struct Day12: Day {
    var caveSystem: CaveSystem

    init(_ input: Input) throws {
        caveSystem = input.decode()!
    }

    func partOne() async -> String {
        let paths = caveSystem.findingPaths(from: "start",
                                            to: "end",
                                            smallCaveVisitCount: 1)
        return "\(paths.count)"
    }

    func partTwo() async -> String {
        let paths = caveSystem.findingPaths(from: "start",
                                            to: "end",
                                            smallCaveVisitCount: 2)
        let uniquePaths = Set(paths)
        return "\(uniquePaths.count)"
    }

    struct CaveSystem: RawRepresentable {
        typealias Cave = String
        typealias Path = [Cave]
        var graph: AdjacencyList<Cave>

        var rawValue: String {
            graph
                .flatMap { node in
                    graph
                        .edges(from: node)
                        .map { edge in
                            "\(node)-\(edge.destination)"
                        }
                }
                .joined(separator: "\n")
        }

        init?(rawValue: String) {
            graph = AdjacencyList()
            let edges = rawValue
                .components(separatedBy: "\n")
                .map {
                    $0.components(separatedBy: "-")
                        .prefix(2)
                }
            for edge in edges {
                let (start, end) = (edge[0], edge[1])
                graph.addUndirectedEdge(from: start, to: end, weight: nil)
            }
        }

        func isSmallCave(_ id: Cave) -> Bool {
            id != "start" && id != "end" && id.first!.isLowercase
        }

        func isLargeCave(_ id: Cave) -> Bool {
            id != "start" && id != "end" && id.first!.isUppercase
        }

        func findingPaths(from start: Cave, to end: Cave, smallCaveVisitCount: Int) -> [Path] {
            var caves = Set(graph.nodes)
            caves.remove(start)

            var counts = CountedSet(caves)
            for cave in caves where isLargeCave(cave) {
                counts[cave] = .max
            }

            if smallCaveVisitCount > 1 {
                return caves
                    .lazy
                    .filter(isSmallCave)
                    .flatMap { (cave: Cave) -> [Path] in
                        // i love side effects
                        counts[cave] = smallCaveVisitCount
                        let p = countPaths(from: start,
                                           to: end,
                                           visitableCaves: counts)
                        counts[cave] = 1
                        return p
                    }
            } else {
                return countPaths(from: start, to: end, visitableCaves: counts)
            }
        }

        private func countPaths(from start: Cave, to end: Cave, visitableCaves: CountedSet<Cave>) -> [Path] {
            let edges = graph
                .edges(from: start)
                .lazy
                .filter {
                    visitableCaves.count(for: $0.destination) != 0
                }

            var remainingVisitable = visitableCaves
            remainingVisitable.remove(start)

            return edges.flatMap { (edge: Edge<Cave>) -> [Path] in
                guard edge.destination != end else {
                    return [[start, end]]
                }

                return countPaths(from: edge.destination,
                                  to: end,
                                  visitableCaves: remainingVisitable)
                    .map { [start] + $0 }
            }
        }
    }
}
