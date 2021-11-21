//
//  Day2.swift
//  
//
//  Created by Aaron Sky on 11/18/21.
//

import Base

struct Day2: Day {
    var rom: [Int]

    init(_ input: Input) throws {
        rom = input.decodeMany(separatedBy: ",", transform: Int.init)
    }

    func partOne() async -> String {
        var program = Intcode(program: rom)

        _ = program.run()
        
        return program.debugDescription
    }

    func partTwo() async -> String {
        ""
    }
}
