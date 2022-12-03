import Foundation

public struct Input {
    enum Error: Swift.Error {
        case fileNotFound(String)
    }

    private var contents: String

    public var raw: String {
        contents
    }

    public var lines: [String] {
        contents.lines
    }

    public init(day: Int, in bundle: Bundle) async throws {
        guard let url = bundle.url(forResource: Input.fileName(for: day),
                                   withExtension: "txt",
                                   subdirectory: "Inputs") else {
            throw Error.fileNotFound("\(Input.fileName(for: day)).txt")
        }

        try await self.init(contentsOf: url)
    }

    init(contentsOf url: URL) async throws {
        contents = try String(String(contentsOf: url).dropLast())
    }

    private static func fileName(for day: Int) -> String {
        "day\(String(format: "%02d", day))"
    }

    public func components<S: StringProtocol>(separatedBy separator: S) -> [String] {
        decodeMany(separatedBy: separator, transform: { String($0) })
    }

    public func decode<T: LosslessStringConvertible>() -> T? {
        decode(T.init)
    }

    public func decode<T: RawRepresentable>() -> T? where T.RawValue == String {
        decode(T.init)
    }

    public func decode<T>(_ transform: @escaping (String) -> T?) -> T? {
        transform(contents)
    }

    public func decodeMany<T: LosslessStringConvertible, S: StringProtocol>(separatedBy separator: S) -> [T] {
        decodeMany(separatedBy: separator, transform: T.init)
    }

    public func decodeMany<T: RawRepresentable, S: StringProtocol>(separatedBy separator: S) -> [T] where T.RawValue == String {
        decodeMany(separatedBy: separator, transform: T.init)
    }

    public func decodeMany<T, S: StringProtocol>(separatedBy separator: S, transform: @escaping (String) -> T?) -> [T] {
        lines
            .filter { !$0.isEmpty } // skip empty lines
            .compactMap(transform)
    }
}

extension String {
    public var lines: [String] {
        components(separatedBy: "\n")
    }
}

extension Character {
    public var alphabeticalIndex: Int? {
        lowercased()
            .first?
            .asciiValue
            .map { Int($0) - 97 }
    }

    public var alphabeticalOrdinal: Int? {
        alphabeticalIndex.map { $0 + 1 }
    }
}
