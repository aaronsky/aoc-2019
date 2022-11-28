import Base

struct Day9: Day {
    var rom: [Int]

    init(_ input: Input) throws {
        rom = input.decodeMany(separatedBy: ",")
    }

    func partOne() async -> String {
        var program = Intcode(program: rom)

        var output: Int?

    loop:
        while true {
            switch program.run() {
            case .waitingForInput:
                program.set(input: 1)
            case .output(let o):
                output = o
            default:
                break loop
            }
        }

        return "\(output ?? -1)"
    }

    func partTwo() async -> String {
        var program = Intcode(program: rom)

        var output: Int?

    loop:
        while true {
            switch program.run() {
            case .waitingForInput:
                program.set(input: 2)
            case .output(let o):
                output = o
            default:
                break loop
            }
        }

        return "\(output ?? -1)"
    }
}
