import Foundation
import XCTest

@testable import Advent2016

class Day4Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2016().day(for: 4)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 0)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 0)
    }

    func testSimpleProgram1() throws {
        let room1 = try XCTUnwrap(Day4.Room(rawValue: "aaaaa-bbb-z-y-x-123[abxyz]"))
        XCTAssertTrue(room1.isReal)

        let room2 = try XCTUnwrap(Day4.Room(rawValue: "a-b-c-d-e-f-g-h-987[abcde]"))
        XCTAssertTrue(room2.isReal)

        let room3 = try XCTUnwrap(Day4.Room(rawValue: "not-a-real-room-404[oarel]"))
        XCTAssertTrue(room3.isReal)

        let room4 = try XCTUnwrap(Day4.Room(rawValue: "totally-real-room-200[decoy]"))
        XCTAssertFalse(room4.isReal)
    }
}
