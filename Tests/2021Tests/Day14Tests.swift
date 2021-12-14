//
//  Day14Tests.swift
//
//
//  Created by Aaron Sky on 12/14/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day14Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 14)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 3230)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 3542388214529)
    }

    func testSimpleProblem1() throws {
        let input = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """

        let formula = try XCTUnwrap(Day14.PolymerFormula(rawValue: input))
        let difference = formula.polymerize(count: 10)

        XCTAssertEqual(difference, 1588)
    }
}
