//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2021().input(for: 1)
        let _ = try Day1(input)
    }
}
