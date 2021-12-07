//
//  ArgumentParser+Concurrency.swift
//  
//
//  Created by Aaron Sky on 12/7/21.
//

import ArgumentParser

/// This is necessary while swift-argument-parser does not support async out of the box
protocol AsyncParsableCommand: ParsableCommand {
    mutating func run() async throws
}

extension AsyncParsableCommand {
    static func main(_ arguments: [String]?) async {
        do {
            var command = try parseAsRoot(arguments)
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}
