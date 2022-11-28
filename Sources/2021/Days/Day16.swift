import Algorithms
import Base

struct Day16: Day {
    var message: Packet

    init(_ input: Input) throws {
        message = input.decode()!
    }

    func partOne() async -> String {
        "\(message.versionSum)"
    }

    func partTwo() async -> String {
        "\(message.evaluated)"
    }

    struct Packet: RawRepresentable {
        var version: Int
        var typeID: Int
        var value: Int = 0
        var subpackets: [Packet] = []

        var rawValue: String {
            ""
        }

        var versionSum: Int {
            version + subpackets.sum(of: \.versionSum)
        }

        var evaluated: Int {
            switch typeID {
            case 0:
                return subpackets.sum(of: \.evaluated)
            case 1:
                return subpackets.product(of: \.evaluated)
            case 2:
                return subpackets.min {
                    $0.evaluated < $1.evaluated
                }!.evaluated
            case 3:
                return subpackets.max {
                    $0.evaluated < $1.evaluated
                }!.evaluated
            case 4:
                return value
            case 5:
                return subpackets[0].evaluated > subpackets[1].evaluated ? 1 : 0
            case 6:
                return subpackets[0].evaluated < subpackets[1].evaluated ? 1 : 0
            case 7:
                return subpackets[0].evaluated == subpackets[1].evaluated ? 1 : 0
            default:
                fatalError("Invalid type ID \(typeID)")
            }
        }

        init(version: Int, typeID: Int) {
            self.version = version
            self.typeID = typeID
        }

        init?(rawValue: String) {
            var bits = rawValue.flatMap {
                Int("\($0)", radix: 16)!
                    .bits
                    .suffix(4)
            }

            self.init(bits: &bits[...])
        }

        private init(bits: inout ArraySlice<Bool>) {
            let version = Int(bits: bits.popFirst(3))
            let typeID = Int(bits: bits.popFirst(3))

            var packet = Packet(version: version, typeID: typeID)

            if packet.typeID == 4 {
                var literal: [Bool] = []

                var shouldContinue = true
                while shouldContinue {
                    let next = bits.popFirst(5)
                    literal.append(contentsOf: next.suffix(4))
                    shouldContinue = next[0] == true
                }

                packet.value = Int(bits: literal)
            } else {
                let mode = bits.popFirst()
                if mode {
                    let subpacketsCount = Int(bits: bits.popFirst(11))

                    for _ in 0..<subpacketsCount {
                        packet.subpackets.append(Packet(bits: &bits))
                    }
                } else {
                    let bitsCount = Int(bits: bits.popFirst(15))
                    var parsedBits = 0

                    while parsedBits < bitsCount {
                        let startCount = bits.count
                        let subpacket = Packet(bits: &bits)
                        let endCount = bits.count

                        parsedBits += startCount - endCount

                        packet.subpackets.append(subpacket)
                    }
                }
            }

            self = packet
        }
    }
}
