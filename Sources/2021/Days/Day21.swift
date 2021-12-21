//
//  Day21.swift
//
//
//  Created by Aaron Sky on 12/21/21.
//

import Algorithms
import Base

struct Day21: Day {
    var game: DiceGame

    init(_ input: Input) throws {
        game = input.decode(DiceGame.init)!
    }

    func partOne() async -> String {
        var game = game
        return "\(game.playDeterministically())"
    }

    func partTwo() async -> String {
        "\(game.playNonDeterministically())"
    }

    struct DiceGame: Hashable {
        struct Player: Hashable {
            static let pattern = Regex(#"Player (?<player>\d+) starting position: (?<position>\d+)"#)

            var space: Int
            var score: Int

            init?(_ rawValue: String) {
                guard let match = Self.pattern.firstMatch(in: rawValue),
                      let positionString = match.capture(withName: "position"),
                      let position = Int(positionString) else {
                          return nil
                      }

                self.init(startingFrom: position)
            }

            init(startingFrom space: Int, score: Int = 0) {
                self.space = space
                self.score = score
            }

            mutating func takeTurn(with roll: Int) {
                for _ in 1...roll {
                    space += 1
                    if space == 11 {
                        space = 1
                    }
                }

                score += space
            }
        }

        var playerOne: Player
        var playerTwo: Player

        init?(_ rawValue: String) {
            let players: [(Int, Player)] = rawValue
                .components(separatedBy: "\n")
                .compactMap {
                    guard let match = Player.pattern.firstMatch(in: $0),
                          let number: Int = match.capture(withName: "player"),
                          let position: Int = match.capture(withName: "position") else {
                              return nil
                          }

                    return (number, Player(startingFrom: position))
                }

            guard players.count == 2,
                  let playerOne = players.first(where: { $0.0 == 1 })?.1,
                  let playerTwo = players.first(where: { $0.0 == 2 })?.1 else {
                      return nil
                  }

            self.init(playerOne: playerOne, playerTwo: playerTwo)
        }

        init(startPlayerOneAt: Int, startPlayerTwoAt: Int) {
            self.init(playerOne: Player(startingFrom: startPlayerOneAt),
                      playerTwo: Player(startingFrom: startPlayerTwoAt))
        }

        init(playerOne: Player, playerTwo: Player) {
            self.playerOne = playerOne
            self.playerTwo = playerTwo
        }

        mutating func playDeterministically() -> Int {
            var dice = (1...100).cycled().makeIterator()
            var diceRollCount = 0

            while playerOne.score < 1000 || playerTwo.score < 1000 {
                playerOne.takeTurn(with: dice.next()! + dice.next()! + dice.next()!)
                diceRollCount += 3
                if playerOne.score >= 1000 {
                    break
                }

                playerTwo.takeTurn(with: dice.next()! + dice.next()! + dice.next()!)
                diceRollCount += 3
                if playerTwo.score >= 1000 {
                    break
                }
            }

            let loser = min(playerOne.score, playerTwo.score)
            
            return diceRollCount * loser
        }

        func playNonDeterministically() -> Int {
            typealias PlayerWinCount = (playerOne: Int, playerTwo: Int)

            var outcomes: [DiceGame: PlayerWinCount] = [:]

            let rollTotalToTimesPossibilities = [
                3: 1,
                4: 3,
                5: 6,
                6: 7,
                7: 6,
                8: 3,
                9: 1
            ]

            func playGame(_ game: DiceGame) -> PlayerWinCount {
                if game.playerOne.score >= 21 {
                    return (1, 0)
                } else if game.playerTwo.score >= 21 {
                    return (0, 1)
                } else if let outcome = outcomes[game] {
                    return outcome
                }

                var wins: PlayerWinCount = (0, 0)

                for (rollTotal, times) in rollTotalToTimesPossibilities {
                    let playerOne = game.playerOne
                    let total = playerOne.space + rollTotal
                    let nextSpace = (total > 10) ? total - 10 : total
                    let newPlayer = Player(startingFrom: nextSpace,
                                           score: playerOne.score + nextSpace)

                    let (playerTwoWins, playerOneWins) = playGame(
                        DiceGame(playerOne: game.playerTwo,
                                 playerTwo: newPlayer)
                    )

                    wins = (
                        wins.0 + playerOneWins * times,
                        wins.1 + playerTwoWins * times
                    )
                }

                outcomes[game] = wins

                return wins
            }

            let (playerOneWins, playerTwoWins) = playGame(self)

            return max(playerOneWins, playerTwoWins)
        }
    }
}
