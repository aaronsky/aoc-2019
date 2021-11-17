//
//  Advent.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation

public protocol Year {
    static var year: Int { get }
    var days: [Int: Day.Type] { get }
    func input(for day: Int) async throws -> Input
}

public protocol Day {
    init(_ input: Input) throws
    func partOne() async -> String
    func partTwo() async -> String
}

public extension Day {
    func partOne() async -> String {
        fatalError("unimplemented \(#function)")
    }

    func partTwo() async -> String {
        fatalError("unimplemented \(#function)")
    }
}
