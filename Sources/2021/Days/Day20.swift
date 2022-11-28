import Algorithms
import Base

struct Day20: Day {
    var image: ImageProcessor

    init(_ input: Input) throws {
        image = input.decode()!
    }

    func partOne() async -> String {
        var image = image

        image.enhanceImage(false)
        image.enhanceImage(true)

        return "\(image.on)"
    }

    func partTwo() async -> String {
        var image = image
        var infinite = false

        for _ in 1...50 {
            image.enhanceImage(infinite)
            infinite.toggle()
        }

        return "\(image.on)"
    }

    struct ImageProcessor: RawRepresentable {
        var lookup: [Bool]
        var image: [Point2: Bool]

        var on: Int {
            image.values.count(of: true)
        }

        var rawValue: String {
            """
            \(lookup.map { $0 ? "#" : "." }.joined())

            \(image.description)
            """
        }

        init?(rawValue: String) {
            let sections = rawValue.components(separatedBy: "\n\n")

            guard sections.count == 2,
                  let algo = sections.first else {
                return nil
            }

            lookup = algo.map { $0 == "#" }

            guard let rows = sections.last?.split(separator: "\n"),
                  !rows.isEmpty else {
                return nil
            }

            image = Dictionary(uniqueKeysWithValues: rows
                                .enumerated()
                                .flatMap { (y, row) in
                row
                    .enumerated()
                    .map { (x, pixel) in
                        (Point2(x: x, y: y), (pixel == "#"))
                    }
            })
        }

        mutating func enhanceImage(_ infinite: Bool) {
            let points = image.keys

            guard let (minX, maxX) = points.map(\.x).minAndMax(),
                  let (minY, maxY) = points.map(\.y).minAndMax() else {
                      return
                  }

            var copy: [Point2: Bool] = [:]

            for y in (minY - 1)...(maxY + 1) {
                for x in (minX - 1)...(maxX + 1) {
                    let p = Point2(x: x, y: y)
                    let bits = p
                        .window()
                        .map {
                            image[$0] ?? infinite
                        }
                    let looker = Int(bits: bits)
                    copy[p] = lookup[looker]
                }
            }

            image = copy
        }
    }
}
