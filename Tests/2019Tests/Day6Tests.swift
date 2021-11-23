//
//  Day6Tests.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day6Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 6)
        let problem = await day.partOne()
        XCTAssertEqual(Int(problem), 496)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }

    func testSimpleProgram1() throws {
        let input = """
            COM)B
            B)C
            C)D
            D)E
            E)F
            B)G
            G)H
            D)I
            E)J
            J)K
            K)L
            """
        let map = try XCTUnwrap(Day6.OrbitMap(rawValue: input))
        XCTAssertEqual(map.map.count, 42)
    }

    func testSimpleProgram2() throws {
        let input = """
            COM)B
            B)C
            C)D
            D)E
            E)F
            B)G
            G)H
            D)I
            E)J
            J)K
            K)L
            K)YOU
            I)SAN
            """
        let map = try XCTUnwrap(Day6.OrbitMap(rawValue: input))
        XCTAssertEqual(map.numberOfOrbitalTransfers(from: .you, to: .santa), 4)
    }
}
