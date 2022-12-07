import Algorithms
import Base
import RegexBuilder

struct Day7: Day {
    var fileSystem: FileSystem

    init(
        _ input: Input
    ) throws {
        fileSystem = input.decode(FileSystem.init(_:))!
    }

    func partOne() async -> String {
        let output = fileSystem
            .directories
            .filter { $0.size <= 100000 }
            .sum(of: \.size)
        return "\(output)"
    }

    func partTwo() async -> String {
        let neededSpace = 30_000_000 - (70_000_000 - fileSystem.root.size)
        let output = fileSystem
            .directories
            .filter { $0.size >= neededSpace }
            .min(of: \.size)!
        return "\(output)"
    }

    struct FileSystem {
        enum Node: Hashable {
            case file(name: String, size: Int)
            case directory(name: String)

            var isDirectory: Bool {
                guard case .directory = self else { return false }
                return true
            }

            var name: String {
                switch self {
                case .directory(let name):
                    return name
                case .file(let name, _):
                    return name
                }
            }
        }

        var root: Tree<Node>
        var directories: [Tree<Node>] {
            root.gather(where: \.isDirectory)
        }

        init?(
            _ rawValue: String
        ) {
            self.root = Tree(.directory(name: "/"))

            var current = root
            for line in rawValue.lines.dropFirst() {
                if line.isEmpty { continue }
                if line.starts(with: "$ cd ") {
                    let nameRef = Reference<String>()
                    let pattern = Regex {
                        "$ cd "
                        Capture(OneOrMore(.any), as: nameRef) { String($0) }
                    }
                    guard let match = line.firstMatch(of: pattern) else { return nil }
                    let name = match[nameRef]
                    switch name {
                    case "..":
                        current = current.parent!
                    default:
                        current = current.children.first(where: { $0.data.name == name })!
                    }
                } else if line.starts(with: "$ ls") {
                    continue
                } else if line.starts(with: "dir ") {
                    let nameRef = Reference<String>()
                    let pattern = Regex {
                        "dir "
                        Capture(OneOrMore(.any), as: nameRef) { String($0) }
                    }
                    guard let match = line.firstMatch(of: pattern) else { return nil }
                    current.append(.directory(name: match[nameRef]))
                } else {
                    let nameRef = Reference<String>()
                    let sizeRef = Reference<Int>()
                    let pattern = Regex {
                        TryCapture(
                            OneOrMore(.digit),
                            as: sizeRef
                        ) {
                            Int($0)
                        }
                        OneOrMore(.whitespace)
                        Capture(OneOrMore(.any), as: nameRef) { String($0) }
                    }
                    guard let match = line.firstMatch(of: pattern) else { return nil }
                    current.append(.file(name: match[nameRef], size: match[sizeRef]))
                }
            }
        }
    }
}

extension Tree where T == Day7.FileSystem.Node {
    var size: Int {
        switch data {
        case .directory:
            return children.sum(of: \.size)
        case .file(_, let size):
            return size
        }
    }
}
