import Foundation

@dynamicMemberLookup
public class Tree<T>: Hashable {
    private lazy var id = ObjectIdentifier(self)
    public let data: T
    public private(set) var children: [Tree<T>]
    public private(set) weak var parent: Tree<T>? = nil

    public init(
        _ data: T,
        children: [Tree<T>] = []
    ) {
        self.data = data
        self.children = children
    }

    public subscript<V>(dynamicMember keyPath: KeyPath<T, V>) -> V {
        return data[keyPath: keyPath]
    }

    public func append(_ data: T, children: [Tree<T>] = []) {
        let newElement = Tree(data, children: children)
        self.children.append(newElement)
        newElement.parent = self
    }

    public func removeFromParent() {
        defer { self.parent = nil }
        guard let removeIndex = parent?.children.firstIndex(of: self) else { return }
        parent?.children.remove(at: removeIndex)
    }

    public func gather(where matches: (Tree<T>) -> Bool) -> [Tree<T>] {
        var found: [Tree<T>] = []

        func matchRecursively(_ node: Tree<T>) {
            if matches(node) {
                found.append(node)
            }
            for child in node.children {
                matchRecursively(child)
            }
        }

        matchRecursively(self)

        return found
    }

    public static func == (lhs: Tree<T>, rhs: Tree<T>) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
