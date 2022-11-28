/// Why aren't tuples Hashable
public struct Pair<T1, T2>: Equatable, Hashable where T1: Equatable & Hashable, T2: Equatable & Hashable {
    public var one: T1
    public var two: T2

    public init(
        _ one: T1,
        _ two: T2
    ) {
        self.one = one
        self.two = two
    }

    public init(
        _ tuple: (T1, T2)
    ) {
        self.init(tuple.0, tuple.1)
    }
}
