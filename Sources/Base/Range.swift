import Foundation

extension Range {
    @inlinable
    public func contains(_ other: Self) -> Bool {
        other.clamped(to: self) == other
    }
}

extension ClosedRange {
    @inlinable
    public func contains(_ other: Self) -> Bool {
        other.clamped(to: self) == other
    }
}
