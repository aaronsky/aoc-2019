import Base
import Testing

@testable import Advent2019

@Test
func day9() async throws {
    let day = try await Year2019().day(for: 9)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 3_765_554_916)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 76642)
}

@Test
func day9_simpleProgram1() {
    var program = Intcode(program: [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99])
    program.run()
    #expect(
        program.debugDescription
            == "[109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"
    )
}

@Test
func day9_simpleProgram2() {
    var output: Int?
    var program = Intcode(program: [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0])
    loop: while true {
        switch program.run() {
        case .waitingForInput:
            program.set(input: 5)
        case .output(let o):
            output = o
        default:
            break loop
        }
    }
    #expect(output?.countDigits == 16)
}

@Test
func day9_simpleProgram3() {
    var output: Int?
    var program = Intcode(program: [104, 1_125_899_906_842_624, 99])
    loop: while true {
        switch program.run() {
        case .waitingForInput:
            program.set(input: 5)
        case .output(let o):
            output = o
        default:
            break loop
        }
    }
    #expect(output == 1_125_899_906_842_624)
}
