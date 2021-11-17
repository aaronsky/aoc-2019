//
//  Day2.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day2: Day {
    var presents: [Present]

    init(_ input: Input) throws {
        presents = try input.decodeMany(separatedBy: "\n")
    }

    func partOne() -> String {
        "\(presents.map { $0.surfaceArea }.reduce(0, +))"
    }

    func partTwo() -> String {
        "\(presents.map { $0.ribbonLength }.reduce(0, +))"
    }

    struct Present: InputStringDecodable {
        var width: Int
        var height: Int
        var length: Int

        var surfaceArea: Int {
            let lw = length * width
            let wh = width * height
            let hl = height * length
            let smallestSide = min(lw, wh, hl)

            return 2 * lw + 2 * wh + 2 * hl + smallestSide
        }

        var ribbonLength: Int {
            let lw = 2 * length + 2 * width
            let wh = 2 * width + 2 * height
            let hl = 2 * height + 2 * length

            let smallestSide = min(lw, wh, hl)
            let volume = length * width * height

            return smallestSide + volume
        }

        init(width: Int, height: Int, length: Int) {
            self.width = width
            self.height = height
            self.length = length
        }

        init?(_ str: String) {
            let dimensions = str
                .components(separatedBy: "x")
                .prefix(3)
                .compactMap(Int.init)

            let (length, width, height) = (dimensions[0], dimensions[1], dimensions[2])

            self.init(width: width, height: height, length: length)
        }
    }
}
