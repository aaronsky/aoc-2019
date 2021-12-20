//
//  Matrix.swift
//
//
//  Created by Aaron Sky on 12/11/21.
//

import Algorithms

public struct Matrix<Element>: Collection, CustomStringConvertible, ExpressibleByArrayLiteral {
    public typealias Index = Array<Element>.Index

    private var elements: [Element]

    public var rowWidth: Int
    public var rows: Int

    public var description: String {
        elements
            .chunks(ofCount: rowWidth)
            .map {
                $0.map(String.init(describing:)).joined()
            }
            .joined()
    }

    public var count: Int {
        elements.count
    }

    public var startIndex: Int {
        elements.startIndex
    }

    public var endIndex: Int {
        elements.endIndex
    }

    public init(_ elements: [Element], rowWidth: Int, rows: Int) {
        self.elements = elements
        self.rowWidth = rowWidth
        self.rows = rows
    }

    public init(_ elements: [Element], rowWidth: Int) {
        self.init(elements, rowWidth: rowWidth, rows: elements.chunks(ofCount: rowWidth).count)
    }

    public init(_ elements: [[Element]]) {
        self.init(elements.flatMap { $0 }, rowWidth: elements.first?.count ?? 0, rows: elements.count)
    }

    public init(repeating: Element, rowWidth: Int, rows: Int) {
        self.init(Array(repeating: repeating, count: rowWidth * rows), rowWidth: rowWidth, rows: rows)
    }

    public init(arrayLiteral elements: Element...) {
        self.init(elements, rowWidth: elements.count, rows: 1)
    }

    public subscript(_ index: Index) -> Element {
        get {
            elements[index]
        }
        set {
            elements[index] = newValue
        }
    }

    public subscript(x: Int, y: Int) -> Element {
        get {
            self[(x, y)]
        }
        set {
            self[(x, y)] = newValue
        }
    }

    public subscript(position: (x: Int, y: Int)) -> Element {
        get {
            guard position.x >= 0 &&
                    position.x < rowWidth &&
                    position.y >= 0 &&
                    position.y < rows
            else {
                fatalError("Matrix out of bounds error: \(position) is not a valid coordinate")
            }

            return self[index(of: position)]
        }
        set {
            guard position.x >= 0 &&
                    position.x < rowWidth &&
                    position.y >= 0 &&
                    position.y < rows
            else {
                return
            }

            self[index(of: position)] = newValue
        }
    }

    public func index(after i: Index) -> Index {
        elements.index(after: i)
    }

    public func position(of index: Index) -> (x: Int, y: Int) {
        (x: index % rowWidth, y: index / rowWidth)
    }

    public func index(of position: (x: Int, y: Int)) -> Index {
        rowWidth * position.y + position.x
    }

    public func indicesSurrounding(index: Index, includingDiagonals: Bool = false) -> [Index] {
        indicesSurrounding(position: position(of: index),
                           includingDiagonals: includingDiagonals)
    }

    public func indicesSurrounding(position: (x: Int, y: Int), includingDiagonals: Bool = false) -> [Index] {
        positionsSurrounding(position: position,
                             includingDiagonals: includingDiagonals)
            .map(index(of:))
    }

    public func positionsSurrounding(index: Index, includingDiagonals: Bool = false) -> [(x: Int, y: Int)] {
        positionsSurrounding(position: position(of: index),
                             includingDiagonals: includingDiagonals)
    }

    public func positionsSurrounding(position: (x: Int, y: Int), includingDiagonals: Bool = false) -> [(x: Int, y: Int)] {
        let (x, y) = position
        var adjacents = [
            (x, y - 1), // N
            (x - 1, y), // W
            (x, y + 1), // S
            (x + 1, y), // E
        ]

        if includingDiagonals {
            adjacents.append(contentsOf: [
                (x - 1, y - 1), // NW
                (x - 1, y + 1), // SW
                (x + 1, y + 1), // SE
                (x + 1, y - 1), // NE
            ])
        }

        return adjacents
            .filter { p in
                p.0 >= 0 &&
                p.0 < rowWidth &&
                p.1 >= 0 &&
                p.1 < rows
            }
    }
}
