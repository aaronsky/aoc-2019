//
//  Day5.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day5: Day {
    var strings: [String]

    init(_ input: Input) throws {
        strings = input.components(separatedBy: "\n")
    }

    func partOne() async -> String {
        "\(countNiceStrings(isNice: isNiceOne))"
    }

    func partTwo() async -> String {
        "\(countNiceStrings(isNice: isNiceTwo))"
    }

    func countNiceStrings(isNice: @escaping (String) -> Bool) -> Int {
        strings
            .lazy
            .count(where: isNice)
    }

    /// A nice string is one with all of the following properties:
    func isNiceOne(_ str: String) -> Bool {
        var previousChar: Character = "\0"

        // It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
        var satisfiesRuleOne = false
        var countVowels = 0
        // It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
        var satisfiesRuleTwo = false
        // It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
        var satisfiesRuleThree = true

        for (i, ch) in str.enumerated() {
            if ch == "a"
                || ch == "e"
                || ch == "i"
                || ch == "o"
                || ch == "u" {
                countVowels += 1

                if countVowels >= 3 {
                    satisfiesRuleOne = true
                }
            }

            if i > 0 {
                assert(previousChar != "\0")

                if ch == previousChar {
                    satisfiesRuleTwo = true
                }

                if previousChar == "a" && ch == "b"
                    || previousChar == "c" && ch == "d"
                    || previousChar == "p" && ch == "q"
                    || previousChar == "x" && ch == "y" {
                    satisfiesRuleThree = false
                }
            }

            previousChar = ch
        }

        return satisfiesRuleOne && satisfiesRuleTwo && satisfiesRuleThree
    }

    /// A nice string is one with all of the following properties:
    func isNiceTwo(_ str: String) -> Bool {
        var previousChar: Character = "\0"

        // It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
        var satisfiesRuleOne = false
        var letterPairs: Set<Pair<Character, Character>> = []
        var consecutiveCharsCount = 1
        // It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
        var satisfiesRuleTwo = false
        var prevPrevChar: Character = "\0"

        for (i, ch) in str.enumerated() {
            if i > 0 {
                assert(previousChar != "\0")

                if previousChar == ch {
                    consecutiveCharsCount += 1
                } else {
                    consecutiveCharsCount = 1
                }

                if consecutiveCharsCount != 3 {
                    let (inserted, _) = letterPairs.insert(Pair(previousChar, ch))
                    if !inserted {
                        satisfiesRuleOne = true
                    }
                }
            }

            if i > 1 {
                assert(prevPrevChar != "\0")

                if prevPrevChar == ch {
                    satisfiesRuleTwo = true
                }
            }

            prevPrevChar = previousChar
            previousChar = ch
        }

        return satisfiesRuleOne && satisfiesRuleTwo
    }
}
