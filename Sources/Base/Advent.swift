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
    func input(for day: Int) throws -> Input
}

public protocol Day: CustomDebugStringConvertible {
    init(_ input: Input) throws
    func partOne() -> String
    func partTwo() -> String
}

public extension Day {
    var debugDescription: String {
        "(\(partOne()), \(partTwo()))"
    }
}

public extension Day {
    func partOne() -> String {
        fatalError("unimplemented \(#function)")
    }

    func partTwo() -> String {
        fatalError("unimplemented \(#function)")
    }
}
