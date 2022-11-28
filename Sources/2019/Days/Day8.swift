import Base

struct Day8: Day {
    var layers: [Layer]

    init(
        _ input: Input
    ) throws {
        layers =
            input.decode {
                [Layer](
                    rawImage: RawImage(
                        pixels: $0,
                        width: 25,
                        height: 6
                    )
                )
            } ?? []
    }

    func partOne() async -> String {
        let combined = Layer(combining: layers)
        return "\(combined.description)"
    }

    func partTwo() async -> String {
        ""
    }

    struct Layer: CustomStringConvertible {
        var pixels: [Pixel]

        private var pixelCounts: [Pixel: Int]
        private var width: Int
        private var height: Int

        var description: String {
            pixels
                .map { $0.description }
                .joined()
        }

        subscript(countFor pixel: Pixel) -> Int {
            pixelCounts[pixel] ?? 0
        }

        init(
            pixels: [Pixel],
            pixelCounts: [Pixel: Int],
            width: Int,
            height: Int
        ) {
            self.pixels = pixels
            self.pixelCounts = pixelCounts
            self.width = width
            self.height = height
        }

        init(
            width: Int,
            height: Int
        ) {
            self.init(
                pixels: Array(repeating: .transparent, count: width * height),
                pixelCounts: [:],
                width: width,
                height: height
            )
        }

        init(
            rawImage: RawImage
        ) {
            var pixels: [Pixel] = []
            var pixelCounts: [Pixel: Int] = [:]
            for pixel in rawImage.pixels {
                guard let p = Pixel(input: pixel) else {
                    fatalError("invalid pixel value \(pixel)")
                }
                pixels.append(p)
                pixelCounts[p, default: 0] += 1
            }
            self.init(
                pixels: pixels,
                pixelCounts: pixelCounts,
                width: rawImage.width,
                height: rawImage.height
            )
        }

        init(
            combining layers: [Layer]
        ) {
            let widthsAndHeights = layers.map {
                Size(width: $0.width, height: $0.height)
            }
            precondition(widthsAndHeights.min() == widthsAndHeights.max())
            var combinedLayer = Layer(width: layers[0].width, height: layers[0].height)
            for layer in layers {
                for (i, layerPixel) in layer.pixels.enumerated() {
                    if combinedLayer.pixels.indices.contains(i) {
                        if combinedLayer.pixels[i] == .transparent {
                            combinedLayer.pixels[i] = layerPixel
                        }
                    } else {
                        combinedLayer.pixels[i] = layerPixel
                    }
                }
            }
            self = combinedLayer
        }
    }

    struct RawImage {
        var pixels: String
        var width: Int
        var height: Int
    }

    enum Pixel: Int, Equatable, Hashable, CustomStringConvertible {
        case black = 0
        case white = 1
        case transparent = 2

        var description: String {
            switch self {
            case .black:
                return "0"
            case .white:
                return "1"
            case .transparent:
                return "2"
            }
        }

        init?(
            input: Character
        ) {
            switch input {
            case "0":
                self = .black
            case "1":
                self = .white
            case "2":
                self = .transparent
            default:
                return nil
            }
        }
    }
}

extension Array where Element == Day8.Layer {
    init(
        rawImage: Day8.RawImage
    ) {
        precondition(rawImage.pixels.count % (rawImage.width * rawImage.height) == 0)
        let layerCount = rawImage.pixels.count / (rawImage.width * rawImage.height)
        var layers: [Day8.Layer] = []
        for l in 0..<layerCount {

            let lowBoundValue = rawImage.width * rawImage.height * l
            let lowBound = rawImage.pixels.index(rawImage.pixels.startIndex, offsetBy: lowBoundValue)

            let highBoundValue = rawImage.width * rawImage.height * (l + 1)
            let highBound = rawImage.pixels.index(rawImage.pixels.startIndex, offsetBy: highBoundValue)

            layers.append(
                Day8.Layer(
                    rawImage: Day8.RawImage(
                        pixels: String(rawImage.pixels[lowBound..<highBound]),
                        width: rawImage.width,
                        height: rawImage.height
                    )
                )
            )
        }
        self = layers
    }
}
