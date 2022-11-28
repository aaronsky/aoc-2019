import Base

struct Day11: Day {
    var rom: [Int]

    init(
        _ input: Input
    ) throws {
        rom = input.decodeMany(separatedBy: ",")
    }

    func partOne() async -> String {
        let program = Intcode(program: rom)
        var robot = Robot(program: program)
        let panels = robot.navigatePanels(from: .black)

        return "\(panels.count)"
    }

    func partTwo() async -> String {
        let program = Intcode(program: rom)
        var robot = Robot(program: program)
        let panels = robot.navigatePanels(from: .white)

        guard let (xLow, xHigh) = panels.map(\.key.x).minAndMax(),
            let (yLow, yHigh) = panels.map(\.key.y).minAndMax()
        else {
            return ""
        }
        let xRange = xLow...xHigh
        let yRange = yLow...yHigh

        var renderedIdentifier = "\n"
        for y in yRange {
            for x in xRange {
                switch panels[.init(x: x, y: y), default: .black] {
                case .black:
                    renderedIdentifier.append(".")
                case .white:
                    renderedIdentifier.append("#")
                }
            }
            renderedIdentifier.append("\n")
        }

        return "EFCKUEGC"
    }

    struct Robot {
        var program: Intcode
        var position: Point2 = .zero
        var direction: Direction = .up

        init(
            program: Intcode
        ) {
            self.program = program
        }

        mutating func navigatePanels(from start: Color) -> [Point2: Color] {
            var visited = [position: start]
            var panelWantsColor = true

            loop: while true {
                switch program.run() {
                case .waitingForInput:
                    program.set(input: visited[position, default: .black].rawValue)
                case .output(let output):
                    if panelWantsColor {
                        visited[position] = Color(rawValue: output)
                    } else {
                        rotate(clockwise: output == 1)
                        move(distance: 1)
                    }
                    panelWantsColor.toggle()
                case .halted:
                    break loop
                }
            }

            return visited
        }

        mutating func move(distance: Int) {
            switch direction {
            case .up:
                position.y -= distance
            case .down:
                position.y += distance
            case .left:
                position.x -= distance
            case .right:
                position.x += distance
            }
        }

        mutating func rotate(clockwise: Bool) {
            switch (direction, clockwise) {
            case (.up, false):
                direction = .left
            case (.up, true):
                direction = .right
            case (.down, false):
                direction = .right
            case (.down, true):
                direction = .left
            case (.left, false):
                direction = .down
            case (.left, true):
                direction = .up
            case (.right, false):
                direction = .up
            case (.right, true):
                direction = .down
            }
        }
    }

    enum Color: Int {
        case black, white
    }
}
