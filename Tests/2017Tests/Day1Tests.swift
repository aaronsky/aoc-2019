//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2017

class Day1Tests: XCTestCase {
    func testProblems() throws {
        let input = try Year2017().input(for: 1)
        let _ = try Day1(input)
    }
}
