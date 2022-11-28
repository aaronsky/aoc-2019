import Base
import Foundation
import XCTest

@testable import Advent2019

class Day9Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 9)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 3_765_554_916)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 76642)
    }

    func testSimpleProgram1() {
        var program = Intcode(program: [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99])
        program.run()
        XCTAssertEqual(
            program.debugDescription,
            "[109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"
        )
    }

    func testSimpleProgram2() {
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
        XCTAssertEqual(output?.countDigits, 16)
    }

    func testSimpleProgram3() {
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
        XCTAssertEqual(output, 1_125_899_906_842_624)
    }
}
