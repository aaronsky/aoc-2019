import Base
import OrderedCollections

struct Day4: Day {
    var game: Game

    init(_ input: Input) throws {
        game = input.decode()!
        precondition(game.boards.count == 100)
    }

    func partOne() async -> String {
        var game = self.game
        let (winner, winningNumber) = game.playUntilFirstWinner()!
        return "\(winner.score(for: winningNumber))"
    }

    func partTwo() async -> String {
        var game = self.game
        let (winner, winningNumber) = game.playUntilLastWinner()!
        return "\(winner.score(for: winningNumber))"
    }

    struct Game: RawRepresentable {
        var draws: [Int]
        var boards: [Board]

        var rawValue: String {
            ""
        }

        init?(rawValue: String) {
            let components = rawValue.components(separatedBy: "\n\n")
            draws = components.first?.components(separatedBy: ",").compactMap(Int.init) ?? []
            boards = components.dropFirst().compactMap(Board.init)
        }

        mutating func playUntilFirstWinner() -> (Board, Int)? {
            for draw in draws {
                for i in boards.indices {
                    if boards[i].markIfNeeded(draw) {
                        return (boards[i], draw)
                    }
                }
            }

            return nil
        }

        mutating func playUntilLastWinner() -> (Board, Int)? {
            var lastWinner: (Board, Int)? = nil
            var boardsToCheck = Set(boards.indices)

            for draw in draws {
                var winners: Set<Range<Array<Board>.Index>.Element> = []

                for i in boardsToCheck {
                    guard !winners.contains(i),
                          boards[i].markIfNeeded(draw) else {
                        continue
                    }

                    lastWinner = (boards[i], draw)
                    winners.insert(i)
                }

                for i in winners {
                    boardsToCheck.remove(i)
                }
            }

            return lastWinner
        }

        struct Board: RawRepresentable {
            var numbers: OrderedSet<Int>
            var width = 5
            var hits: Set<Array<Int>.Index> = []

            var rawValue: String {
                ""
            }

            init?(rawValue: String) {
                var numbers: OrderedSet<Int> = []

                let rows = rawValue.components(separatedBy: "\n")
                precondition(rows.count == 5)

                for row in rows {
                    let cols = row.components(separatedBy: " ").filter { !$0.isEmpty }
                    precondition(cols.count == 5)

                    for item in cols {
                        guard let number = Int(item) else {
                            preconditionFailure("\(item) is not an integer")
                        }

                        numbers.append(number)
                    }
                }

                self.numbers = numbers
            }

            subscript(x: Int, y: Int) -> Int {
                numbers[width * y + x]
            }

            /// - Returns:true if the change causes a bingo
            mutating func markIfNeeded(_ number: Int) -> Bool {
                guard let index = numbers.firstIndex(of: number),
                      !hits.contains(index) else {
                          return false
                      }

                hits.insert(index)

                if hits.count < width {
                    return false
                }

                var rowHits: [Int: Int] = [:]
                var colHits: [Int: Int] = [:]
                for point in hits.map(position) {
                    rowHits[point.x, default: 0] += 1
                    colHits[point.y, default: 0] += 1
                    if rowHits[point.x] == width ||
                        colHits[point.y] == width {
                        return true
                    }
                }

                return false
            }

            func position(of index: OrderedSet<Int>.Index) -> (x: Int, y: Int) {
                (x: index % width, y: index / width)
            }

            func score(for hit: Int) -> Int {
                hit * numbers
                    .indices
                    .lazy
                    .filter { !hits.contains($0) }
                    .map { numbers[$0] }
                    .sum
            }
        }
    }
}
