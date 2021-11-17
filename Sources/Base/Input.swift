//
//  Input.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation

public struct Input {
    enum Error: Swift.Error {
        case fileNotFound(String)
    }

    private var contents: String

    public var raw: String {
        contents
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
        contents = try String(contentsOf: url)
    }

    private static func fileName(for day: Int) -> String {
        "day\(String(format: "%02d", day))"
    }

    public func decode<T: RawRepresentable>() -> T? where T.RawValue == String {
        T(rawValue: contents)
    }

    public func decodeMany<T: RawRepresentable>(separatedBy separator: String) throws -> [T] where T.RawValue == String {
        contents
            .components(separatedBy: separator)
            .filter { !$0.isEmpty } // skip empty lines
            .compactMap(T.init)
    }
}

// MARK: - Swift types are now RawRepresentable

extension String: RawRepresentable {
    public var rawValue: Self {
        self
    }

    public init?(rawValue: Self) {
        self = rawValue
    }
}

extension Int: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Int8: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Int16: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Int32: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Int64: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension UInt: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension UInt8: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension UInt16: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension UInt32: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension UInt64: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Float: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Double: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}

extension Bool: RawRepresentable {
    public var rawValue: String {
        "\(self)"
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}
