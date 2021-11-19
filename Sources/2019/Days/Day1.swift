//
//  Day1.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Base

struct Day1: Day {
    var modules: [Int]

    init(_ input: Input) throws {
        modules = input.decodeMany(separatedBy: "\n", transform: Int.init)
    }

    func partOne() async -> String {
        "\(fuelRequiredToLaunch())"
    }

    func partTwo() async -> String {
        ""
    }

    func fuelRequiredToLaunch() -> Int {
        modules.reduce(into: 0) { acc, module in
            let minFuel = fuelRequired(forMass: module)

            if minFuel <= 0 {
                return
            }

            var remainingMass = minFuel
            var additionalFuel = 0

            while remainingMass > 0 {
                remainingMass = fuelRequired(forMass: remainingMass)

                if remainingMass <= 0 {
                    break
                }

                additionalFuel += remainingMass
            }

            acc += minFuel + additionalFuel
        }
    }

    func fuelRequired(forMass mass: Int) -> Int {
        mass / 3 - 2
    }
}
