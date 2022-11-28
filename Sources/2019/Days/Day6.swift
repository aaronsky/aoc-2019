import Base

struct Day6: Day {
    var map: OrbitMap

    init(
        _ input: Input
    ) throws {
        map = input.decode()!
    }

    func partOne() async -> String {
        "\(map.numberOfOrbitalTransfers(from: .you, to: .santa))"
    }

    func partTwo() async -> String {
        ""
    }

    struct OrbitMap: RawRepresentable {
        var objects: Set<OrbitalObject>
        var reverseLookup: [OrbitalObject: OrbitalObject]

        var rawValue: String {
            ""
        }

        var map: AdjacencyList<OrbitalObject> {
            var pathMap: AdjacencyList<OrbitalObject> = []

            for object in objects {
                pathMap.insert(object)
                var current = object
                while let next = reverseLookup[current] {
                    current = next
                    pathMap.addDirectedEdge(
                        from: object,
                        to: current,
                        weight: nil
                    )
                }
            }

            return pathMap
        }

        init?(
            rawValue: String
        ) {
            var allObjects: Set<OrbitalObject> = []
            var reverseLookup: [OrbitalObject: OrbitalObject] = [:]
            for line in rawValue.components(separatedBy: "\n") {
                let adjacency =
                    line
                    .components(separatedBy: ")")
                    .prefix(2)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                guard adjacency.count == 2 else {
                    continue
                }
                guard
                    let key = OrbitalObject(rawValue: adjacency[1]),
                    let value = OrbitalObject(rawValue: adjacency[0])
                else {
                    continue
                }
                allObjects.insert(key)
                reverseLookup[key] = value
            }

            self.objects = allObjects
            self.reverseLookup = reverseLookup
        }

        func numberOfOrbitalTransfers(from source: OrbitalObject, to destination: OrbitalObject) -> Int {
            let map = self.map
            precondition(map.contains(source))
            precondition(map.contains(destination))
            let sourceOrbits =
                map
                .edges(from: source)
                .map { $0.destination }
            let destinationOrbits =
                map
                .edges(from: destination)
                .map { $0.destination }
            var lastMatchingSourceIndex = sourceOrbits.index(before: sourceOrbits.endIndex)
            var lastMatchingDestinationIndex = destinationOrbits.index(before: destinationOrbits.endIndex)
            for (reverseIndex, (a, b)) in sourceOrbits.reversed().zip(destinationOrbits.reversed()).enumerated() {
                if a == b {
                    break
                }
                lastMatchingSourceIndex = sourceOrbits.index(sourceOrbits.endIndex, offsetBy: -1 - reverseIndex)
                lastMatchingDestinationIndex = destinationOrbits.index(
                    destinationOrbits.endIndex,
                    offsetBy: -1 - reverseIndex
                )
            }

            let path =
                sourceOrbits[..<lastMatchingSourceIndex] + destinationOrbits[...lastMatchingDestinationIndex].reversed()

            return path.index(before: path.endIndex)
        }
    }

    enum OrbitalObject: Equatable, Hashable, RawRepresentable {
        case you
        case santa
        case object(String)

        var rawValue: String {
            switch self {
            case .you:
                return "YOU"
            case .santa:
                return "SAN"
            case .object(let string):
                return string
            }
        }

        init?(
            rawValue: String
        ) {
            switch rawValue {
            case "YOU":
                self = .you
            case "SAN":
                self = .santa
            case let obj:
                self = .object(obj)
            }
        }
    }
}
