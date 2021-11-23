//
//  Day9Tests.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

import Foundation
import Base
import XCTest
@testable import Advent2019

class Day9Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 9)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 3765554916)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 76642)
    }

    func testSimpleProgram1() {
        var program = Intcode(program: [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99])
        program.run()
        XCTAssertEqual(program.debugDescription, "[109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]")
    }

    func testSimpleProgram2() {
        var output: Int? = nil
        var program = Intcode(program: [1102, 34915192, 34915192, 7, 4, 7, 99, 0])
    loop:
        while true {
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
        var output: Int? = nil
        var program = Intcode(program: [104, 1125899906842624, 99])
    loop:
        while true {
            switch program.run() {
            case .waitingForInput:
                program.set(input: 5)
            case .output(let o):
                output = o
            default:
                break loop
            }
        }
        XCTAssertEqual(output, 1125899906842624)
    }
}
