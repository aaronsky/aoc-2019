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

    public func components<S: StringProtocol>(separatedBy separator: S) -> [String] {
        decodeMany(separatedBy: separator, transform: String.init)
    }

    public func decode<T: RawRepresentable>() -> T? where T.RawValue == String {
        decode(T.init)
    }

    public func decode<T>(_ transform: @escaping (String) -> T?) -> T? {
        transform(contents)
    }

    public func decodeMany<T: RawRepresentable, S: StringProtocol>(separatedBy separator: S) -> [T] where T.RawValue == String {
        decodeMany(separatedBy: separator, transform: T.init)
    }

    public func decodeMany<T, S: StringProtocol>(separatedBy separator: S, transform: @escaping (String) -> T?) -> [T] {
        contents
            .components(separatedBy: separator)
            .filter { !$0.isEmpty } // skip empty lines
            .compactMap(transform)
    }
}

extension Int: RawRepresentable {
    public var rawValue: String {
        description
    }

    public init?(rawValue: String) {
        self.init(rawValue)
    }
}
