//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2016

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2016().input(for: 1)
        let _ = try Day1(input)
    }
}
