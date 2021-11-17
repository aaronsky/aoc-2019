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

    public init(day: Int, in bundle: Bundle) throws {
        guard let url = bundle.url(forResource: Input.fileName(for: day),
                                   withExtension: "txt",
                                   subdirectory: "Inputs") else {
            throw Error.fileNotFound("\(Input.fileName(for: day)).txt")
        }

        try self.init(contentsOf: url)
    }

    init(contentsOf url: URL) throws {
        contents = try String(contentsOf: url)
    }

    private static func fileName(for day: Int) -> String {
        "day\(String(format: "%02d", day))"
    }

    public func decode<T: InputStringDecodable>() -> T? {
        T(contents)
    }

    public func decodeMany<T: InputStringDecodable>(separatedBy separator: String) throws -> [T] {
        contents
            .components(separatedBy: separator)
            .filter { !$0.isEmpty } // skip empty lines
            .compactMap(T.init)
    }
}

public protocol InputStringDecodable {
    init?(_ str: String)
}

extension String: InputStringDecodable {
    public init?(_ str: String) {
        self = str
    }
}

extension Int: InputStringDecodable {}
extension Int8: InputStringDecodable {}
extension Int16: InputStringDecodable {}
extension Int32: InputStringDecodable {}
extension Int64: InputStringDecodable {}
extension UInt: InputStringDecodable {}
extension UInt8: InputStringDecodable {}
extension UInt16: InputStringDecodable {}
extension UInt32: InputStringDecodable {}
extension UInt64: InputStringDecodable {}

extension Float: InputStringDecodable {}
extension Double: InputStringDecodable {}

extension Bool: InputStringDecodable {}

extension RawRepresentable where Self: InputStringDecodable, RawValue: InputStringDecodable {}
