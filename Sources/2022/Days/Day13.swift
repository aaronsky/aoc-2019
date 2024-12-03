import Algorithms
import Base
import Foundation

struct Day13: Day {
    var packets: [(Packet, Packet)]

    init(_ input: Input) throws {
        let decoder = JSONDecoder()
        packets =
            try input
            .raw
            .split(separator: "\n\n")
            .compactMap { element in
                let lines = element.split(separator: "\n")
                guard
                    lines.count == 2,
                    let leftData = lines[0].data(using: .utf8),
                    let rightData = lines[1].data(using: .utf8)
                else { return nil }
                let left = try decoder.decode(Packet.self, from: leftData)
                let right = try decoder.decode(Packet.self, from: rightData)
                return (left, right)
            }
    }

    func partOne() async -> String {
        let sum =
            packets
            .enumerated()
            .filter { (_, pair) in
                pair.0 < pair.1
            }
            .sum { $0.offset + 1 }

        return "\(sum)"
    }

    func partTwo() async -> String {
        let packets = packets.flatMap { [$0.0, $0.1] }
        let dividerPackets: [Packet] = [
            .array([.array([.int(2)])]),
            .array([.array([.int(6)])]),
        ]

        let sortedPackets = (packets + dividerPackets).sorted()
        let indexOfTwo = sortedPackets.firstIndex(of: dividerPackets[0])! + 1
        let indexOfSix = sortedPackets.firstIndex(of: dividerPackets[1])! + 1
        let product = indexOfTwo * indexOfSix

        return "\(product)"
    }

    enum Packet: Comparable, Decodable, ExpressibleByIntegerLiteral, ExpressibleByArrayLiteral {
        case int(Int)
        case array([Packet])

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let int = try? container.decode(Int.self) {
                self = .int(int)
            } else if let array = try? container.decode([Packet].self) {
                self = .array(array)
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "invalid JSON structure or the input was not JSON"
                )
            }
        }

        init(integerLiteral value: Int) {
            self = .int(value)
        }

        init(arrayLiteral elements: Packet...) {
            self = .array(elements)
        }

        static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.int(let one), .int(let two)):
                return one < two
            case (.array(let one), .array(let two)):
                return one.lexicographicallyPrecedes(two)
            case (.array, .int):
                return lhs < .array([rhs])
            case (.int, .array):
                return .array([lhs]) < rhs
            }
        }
    }
}
