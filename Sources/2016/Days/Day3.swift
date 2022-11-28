import Base

struct Day3: Day {
    var input: Input

    init(
        _ input: Input
    ) throws {
        self.input = input
    }

    func partOne() async -> String {
        let triangles: [Triangle] =
            input
            .decodeMany(separatedBy: "\n")
            .filter { $0.isValid }
        return "\(triangles.count)"
    }

    func partTwo() async -> String {
        let triangles: [Triangle] =
            input
            .decodeMany(separatedBy: "\n")
            .chunks(ofCount: 3)
            .flatMap { (rows: ArraySlice<Triangle>) -> [Triangle] in
                let (row0, row1, row2) = (
                    rows[rows.startIndex],
                    rows[rows.index(after: rows.startIndex)],
                    rows[rows.index(before: rows.endIndex)]
                )
                return [
                    Triangle(a: row0.a, b: row1.a, c: row2.a),
                    Triangle(a: row0.b, b: row1.b, c: row2.b),
                    Triangle(a: row0.c, b: row1.c, c: row2.c),
                ]
            }
            .filter { $0.isValid }
        return "\(triangles.count)"
    }

    struct Triangle: RawRepresentable {
        var a: Int
        var b: Int
        var c: Int

        var isValid: Bool {
            a + b > c && a + c > b && b + c > a
        }

        var rawValue: String {
            "\(a) \(b) \(c)"
        }

        init(
            a: Int,
            b: Int,
            c: Int
        ) {
            self.a = a
            self.b = b
            self.c = c
        }

        init?(
            rawValue: String
        ) {
            let components =
                rawValue
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
                .filter { !$0.isEmpty }
                .prefix(3)

            guard components.count == 3 else {
                return nil
            }

            guard let a = Int(components[0]),
                let b = Int(components[1]),
                let c = Int(components[2])
            else {
                return nil
            }

            self.init(a: a, b: b, c: c)
        }
    }
}
