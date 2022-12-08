import Algorithms
import Base

struct Day8: Day {
    var grid: Matrix<Int>
    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    init(_ input: Input) throws {
        grid = Matrix(input.lines.map { $0.map { Int(String($0))! } })
    }

    func partOne() async -> String {
        var totalVisible = 0

        for index in grid.indices {
            let (x, y) = grid.position(of: index)
            for (dx, dy) in directions {
                var nx = x + dx
                var ny = y + dy

                while (0..<grid.rows).contains(nx) && (0..<grid.rowWidth).contains(ny) && grid[nx, ny] < grid[x, y] {
                    nx += dx
                    ny += dy
                }

                guard (0..<grid.rows).contains(nx) && (0..<grid.rowWidth).contains(ny) else {
                    totalVisible += 1
                    break
                }
            }
        }

        return "\(totalVisible)"
    }

    func partTwo() async -> String {
        var totalVisible = 0

        for index in grid.indices {
            let (x, y) = grid.position(of: index)
            var score = 1

            for (dx, dy) in directions {
                var current = 0
                var nx = x + dx
                var ny = y + dy

                while (0..<grid.rows).contains(nx) && (0..<grid.rowWidth).contains(ny) {
                    current += 1

                    if grid[nx, ny] >= grid[x, y] {
                        break
                    }

                    nx += dx
                    ny += dy
                }

                score *= current
            }

            totalVisible = max(totalVisible, score)
        }

        return "\(totalVisible)"
    }
}
