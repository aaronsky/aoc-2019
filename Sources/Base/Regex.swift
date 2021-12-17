//
//  Regex.swift
//  
//
//  Licensed from Adam Sharp on 11/30/21.
//  https://github.com/sharplet/Regex
//

//  The MIT License (MIT)
//
//  Copyright (c) 2015 Adam Sharp
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation

public struct Regex: CustomStringConvertible, CustomDebugStringConvertible {
    let regularExpression: NSRegularExpression

    /// Create a `Regex` based on a pattern string.
    ///
    /// If `pattern` is not a valid regular expression, an error is thrown
    /// describing the failure.
    ///
    /// - parameters:
    ///     - pattern: A pattern string describing the regex.
    ///     - options: Configure regular expression matching options.
    ///       For details, see `Regex.Options`.
    ///
    /// - throws: A value of `ErrorType` describing the invalid regular expression.
    public init(string pattern: String, options: Options = []) throws {
        regularExpression = try NSRegularExpression(pattern: pattern,
                                                    options: .init(options))
    }

    /// Create a `Regex` based on a static pattern string.
    ///
    /// Unlike `Regex.init(string:)` this initialiser is not failable. If `pattern`
    /// is an invalid regular expression, it is considered programmer error rather
    /// than a recoverable runtime error, so this initialiser instead raises a
    /// precondition failure.
    ///
    /// - requires: `pattern` is a valid regular expression.
    ///
    /// - parameters:
    ///     - pattern: A pattern string describing the regex.
    ///     - options: Configure regular expression matching options.
    ///       For details, see `Regex.Options`.
    public init(_ pattern: StaticString, options: Options = []) {
        do {
            regularExpression = try NSRegularExpression(pattern: pattern.description,
                                                        options: .init(options))
        } catch {
            preconditionFailure("unexpected error creating regex: \(error)")
        }
    }

    /// Returns `true` if the regex matches `string`, otherwise returns `false`.
    ///
    /// - parameter string: The string to test.
    ///
    /// - returns: `true` if the regular expression matches, otherwise `false`.
    ///
    /// - note: If the match is successful, `Regex.lastMatch` will be set with the
    ///   result of the match.
    public func matches(_ string: String) -> Bool {
        firstMatch(in: string) != nil
    }

    /// If the regex matches `string`, returns a `MatchResult` describing the
    /// first matched string and any captures. If there are no matches, returns
    /// `nil`.
    ///
    /// - parameter string: The string to match against.
    ///
    /// - returns: An optional `MatchResult` describing the first match, or `nil`.
    ///
    /// - note: If the match is successful, the result is also stored in `Regex.lastMatch`.
    public func firstMatch(in string: String) -> MatchResult? {
        regularExpression
            .firstMatch(in: string, options: [], range: string.entireRange)
            .map { MatchResult(string, $0) }
    }

    /// If the regex matches `string`, returns an array of `MatchResult`, describing
    /// every match inside `string`. If there are no matches, returns an empty
    /// array.
    ///
    /// - parameter string: The string to match against.
    ///
    /// - returns: An array of `MatchResult` describing every match in `string`.
    ///
    /// - note: If there is at least one match, the first is stored in `Regex.lastMatch`.
    public func allMatches(in string: String) -> [MatchResult] {
        regularExpression
            .matches(in: string, options: [], range: string.entireRange)
            .map { MatchResult(string, $0) }
    }

    public var description: String {
        regularExpression.pattern
    }

    public var debugDescription: String {
        "/\(description)/"
    }
}

extension Regex {
    /// `Options` defines alternate behaviours of regular expressions when matching.
    public struct Options: OptionSet {
        /// Ignores the case of letters when matching.
        ///
        /// Example:
        ///
        ///     let a = Regex("a", options: .ignoreCase)
        ///     a.allMatches(in: "aA").map { $0.matchedString } // ["a", "A"]
        public static let ignoreCase = Options(rawValue: 1)

        /// Ignore any metacharacters in the pattern, treating every character as
        /// a literal.
        ///
        /// Example:
        ///
        ///     let parens = Regex("()", options: .ignoreMetacharacters)
        ///     parens.matches("()") // true
        public static let ignoreMetacharacters = Options(rawValue: 1 << 1)

        /// By default, "^" matches the beginning of the string and "$" matches the
        /// end of the string, ignoring any newlines. With this option, "^" will
        /// the beginning of each line, and "$" will match the end of each line.
        ///
        /// Example:
        ///
        ///     let foo = Regex("^foo", options: .anchorsMatchLines)
        ///     foo.allMatches(in: "foo\nbar\nfoo\n").count // 2
        public static let anchorsMatchLines = Options(rawValue: 1 << 2)

        /// Usually, "." matches all characters except newlines (\n). Using this
        /// this options will allow "." to match newLines
        ///
        /// Example:
        ///
        ///     let newLines = Regex("test.test", options: .dotMatchesLineSeparators)
        ///     newLines.allMatches(in: "test\ntest").count // 1
        public static let dotMatchesLineSeparators = Options(rawValue: 1 << 3)

        /// Ignore whitespace and #-prefixed comments in the pattern.
        ///
        /// Example:
        ///
        ///     let newLines = Regex("test test # this is a regex", options: .allowCommentsAndWhitespace)
        ///     newLines.allMatches(in: "testtest").count // 2
        public static let allowCommentsAndWhitespace = Options(rawValue: 1 << 4)

        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }
}

private extension NSRegularExpression.Options {
    /// Transform an instance of `Regex.Options` into the equivalent `NSRegularExpression.Options`.
    ///
    /// - returns: The equivalent `NSRegularExpression.Options`.
    init(_ options: Regex.Options) {
        self.init()

        if options.contains(.ignoreCase) {
            insert(.caseInsensitive)
        }
        if options.contains(.ignoreMetacharacters) {
            insert(.ignoreMetacharacters)
        }
        if options.contains(.anchorsMatchLines) {
            insert(.anchorsMatchLines)
        }
        if options.contains(.dotMatchesLineSeparators) {
            insert(.dotMatchesLineSeparators)
        }
        if options.contains(.allowCommentsAndWhitespace) {
            insert(.allowCommentsAndWhitespace)
        }
    }
}

// MARK: - Pattern matching

/// Match `regex` on the left with some `string` on the right. Equivalent to
/// `regex.matches(string)`, and allows for the use of a `Regex` in pattern
/// matching contexts, e.g.:
///
///     switch Regex("hello (\\w+)") {
///     case "hello world":
///       // successful match
///     }
///
/// - parameters:
///     - regex: The regular expression to match against.
///     - string: The string to test.
///
/// - returns: `true` if the regular expression matches, otherwise `false`.
public func ~= (regex: Regex, string: String) -> Bool {
    regex.matches(string)
}

/// Match `string` on the left with some `regex` on the right. Equivalent to
/// `regex.matches(string)`, and allows for the use of a `Regex` in pattern
/// matching contexts, e.g.:
///
///     switch "hello world" {
///     case Regex("hello (\\w+)"):
///       // successful match
///     }
///
/// - parameters:
///     - regex: The regular expression to match against.
///     - string: The string to test.
///
/// - returns: `true` if the regular expression matches, otherwise `false`.
public func ~= (string: String, regex: Regex) -> Bool {
    regex.matches(string)
}

// MARK: - Conformances

extension Regex: Hashable {}

extension Regex: Codable {
    public init(from decoder: Decoder) throws {
        let string = try decoder.singleValueContainer().decode(String.self)
        try self.init(string: string)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(regularExpression.pattern)
    }
}

extension Regex {
    /// A `MatchResult` encapsulates the result of a single match in a string,
    /// providing access to the matched string, as well as any capture groups within
    /// that string.
    public struct MatchResult {
        private let result: LazyResult

        /// The entire matched string.
        ///
        /// Example:
        ///
        ///     let pattern = Regex("a*")
        ///
        ///     if let match = pattern.firstMatch(in: "aaa") {
        ///       match.matchedString // "aaa"
        ///     }
        ///
        ///     if let match = pattern.firstMatch(in: "bbb") {
        ///       match.matchedString // ""
        ///     }
        public var matchedString: String {
            result.matchedString
        }

        /// The range of the matched string.
        public var range: Range<String.Index> {
            result.range
        }

        /// The matching string for each capture group in the regular expression
        /// (if any).
        ///
        /// **Note:** Usually if the match was successful, the captures will by
        /// definition be non-nil. However if a given capture group is optional, the
        /// captured string may also be nil, depending on the particular string that
        /// is being matched against.
        ///
        /// Example:
        ///
        ///     let regex = Regex("(a)?(b)")
        ///
        ///     regex.firstMatch(in: "ab")?.captures // [Optional("a"), Optional("b")]
        ///     regex.firstMatch(in: "b")?.captures // [nil, Optional("b")]
        public var captures: [String?] {
            result.captures
        }

        /// The ranges of each capture (if any).
        ///
        /// - seealso: The discussion and example for `MatchResult.captures`.
        public var captureRanges: [Range<String.Index>?] {
            result.captureRanges
        }

        var matchResult: NSTextCheckingResult {
            result.result
        }

        init(_ string: String, _ result: NSTextCheckingResult) {
            self.result = LazyResult(string, result)
        }

        public func capture(withName name: String) -> String? {
            let string = result.string
            let nsRange = matchResult.range(withName: name)
            guard nsRange.location != NSNotFound,
                  let range = Range(nsRange, in: string) else {
                      return nil
                  }

            return String(string[range])
        }

        public func capture<T: RawRepresentable>(withName name: String) -> T? where T.RawValue == String {
            guard let capture = capture(withName: name),
                  let value = T(rawValue: capture) else {
                      return nil
                  }
            return value
        }

        private final class LazyResult {
            let string: String
            let result: NSTextCheckingResult

            lazy var range: Range<String.Index> = {
                Range(result.range, in: string)!
            }()

            lazy var captures: [String?] = {
                captureRanges.map { range in
                    range.map {
                        String(string[$0])
                    }
                }
            }()

            lazy var captureRanges: [Range<String.Index>?] = {
                result
                    .ranges
                    .dropFirst()
                    .map { Range($0, in: string) }
            }()

            lazy var matchedString: String = {
                let range = Range(result.range, in: string)!
                return String(string[range])
            }()

            init(_ string: String, _ result: NSTextCheckingResult) {
                self.string = string
                self.result = result
            }
        }
    }
}

private extension NSTextCheckingResult {
    var ranges: [NSRange] {
        stride(from: 0,
               to: numberOfRanges,
               by: 1)
            .map(range(at:))
    }
}

private extension String {
    var entireRange: NSRange {
        NSRange(location: 0, length: utf16.count)
    }
}

extension String {
    // MARK: Replacing the first match (mutating)

    /// If `regex` matches at least one substring, replace the first match with
    /// `template`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - parameters:
    ///     - regex: A regular expression to match against `self`.
    ///     - template: A template string used to replace matches.
    public mutating func replaceFirst(matching regex: Regex, with template: String) {
        if let match = regex.firstMatch(in: self) {
            let replacement = regex
                .regularExpression
                .replacementString(for: match.matchResult,
                                      in: self,
                                      offset: 0,
                                      template: template)

            replaceSubrange(match.range, with: replacement)
        }
    }

    /// If the regular expression described by `pattern` matches at least one
    /// substring, replace the first match with `template`.
    ///
    /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - requires: `pattern` is a valid regular expression. Invalid regular
    ///   expressions will cause this method to trap.
    ///
    /// - parameters:
    ///     - pattern: A regular expression pattern to match against `self`.
    ///     - template: A template string used to replace matches.
    public mutating func replaceFirst(matching pattern: StaticString, with template: String) {
        replaceFirst(matching: Regex(pattern), with: template)
    }

    // MARK: Replacing the first match (nonmutating)

    /// Returns a new string where the first match of `regex` is replaced with
    /// `template`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - parameters:
    ///     - regex: A regular expression to match against `self`.
    ///     - template: A template string used to replace matches.
    ///
    /// - returns: A string with the first match of `regex` replaced by `template`.
    public func replacingFirst(matching regex: Regex, with template: String) -> String {
        var string = self
        string.replaceFirst(matching: regex, with: template)
        return string
    }

    /// Returns a new string where the first match of the regular expression
    /// described by `pattern` is replaced with `template`.
    ///
    /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - requires: `pattern` is a valid regular expression. Invalid regular
    ///   expressions will cause this method to trap.
    ///
    /// - parameters:
    ///     - pattern: A regular expression pattern to match against `self`.
    ///     - template: A template string used to replace matches.
    ///
    /// - returns: A string with the first match of `pattern` replaced by `template`.
    public func replacingFirst(matching pattern: StaticString, with template: String) -> String {
        replacingFirst(matching: Regex(pattern), with: template)
    }

    // MARK: Replacing all matches (mutating)

    /// Replace each substring matched by `regex` with `template`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - parameters:
    ///     - regex: A regular expression to match against `self`.
    ///     - template: A template string used to replace matches.
    public mutating func replaceAll(matching regex: Regex, with template: String) {
        for match in regex.allMatches(in: self).reversed() {
            let replacement = regex
                .regularExpression
                .replacementString(for: match.matchResult,
                                      in: self,
                                      offset: 0,
                                      template: template)

            replaceSubrange(match.range, with: replacement)
        }
    }

    /// Replace each substring matched by the regular expression described in
    /// `pattern` with `template`.
    ///
    /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - requires: `pattern` is a valid regular expression. Invalid regular
    ///   expressions will cause this method to trap.
    ///
    /// - parameters:
    ///     - pattern: A regular expression pattern to match against `self`.
    ///     - template: A template string used to replace matches.
    public mutating func replaceAll(matching pattern: StaticString, with template: String) {
        replaceAll(matching: Regex(pattern), with: template)
    }

    // MARK: Replacing all matches (nonmutating)

    /// Returns a new string where each substring matched by `regex` is replaced
    /// with `template`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - parameters:
    ///     - regex: A regular expression to match against `self`.
    ///     - template: A template string used to replace matches.
    ///
    /// - returns: A string with all matches of `regex` replaced by `template`.
    public func replacingAll(matching regex: Regex, with template: String) -> String {
        var string = self
        string.replaceAll(matching: regex, with: template)
        return string
    }

    /// Returns a new string where each substring matched by the regular
    /// expression described in `pattern` is replaced with `template`.
    ///
    /// Convenience overload that accepts a `StaticString` instead of a `Regex`.
    ///
    /// The template string may be a literal string, or include template variables:
    /// the variable `$0` will be replaced with the entire matched substring, `$1`
    /// with the first capture group, etc.
    ///
    /// For example, to include the literal string "$1" in the replacement string,
    /// you must escape the "$": `\$1`.
    ///
    /// - requires: `pattern` is a valid regular expression. Invalid regular
    ///   expressions will cause this method to trap.
    ///
    /// - parameters:
    ///     - pattern: A regular expression pattern to match against `self`.
    ///     - template: A template string used to replace matches.
    ///
    /// - returns: A string with all matches of `pattern` replaced by `template`.
    public func replacingAll(matching pattern: StaticString, with template: String) -> String {
        replacingAll(matching: Regex(pattern), with: template)
    }
}
