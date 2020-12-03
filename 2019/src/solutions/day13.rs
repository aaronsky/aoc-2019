use util::Point2;

#[derive(Debug, Clone, Copy)]
pub enum Identifier {
    Empty = 0,
    Wall = 1,
    Block = 2,
    Paddle = 3,
    Ball = 4,
}

impl From<i64> for Identifier {
    fn from(o: i64) -> Self {
        match o {
            0 => Identifier::Empty,
            1 => Identifier::Wall,
            2 => Identifier::Block,
            3 => Identifier::Paddle,
            4 => Identifier::Ball,
            wrong => panic!("invalid input {} for Identifier::from", wrong),
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Tile {
    position: Point2,
    id: Identifier,
}

#[derive(Debug, Clone, Copy)]
pub enum JoystickPosition {
    Left = -1,
    Neutral = 0,
    Right = 1,
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::intcode::{Intcode, Interrupt};
    use util;
    use util::ListInput;

    #[test]
    fn test_advent_puzzle() {
        let mut score = None;
        let ListInput(rom) = util::load_input_file("day13.txt").unwrap();
        let mut program = Intcode::new(&rom);

        let mut tile_position_buffer: [Option<i32>; 2] = [None, None];
        let mut ball: Option<Tile> = None;
        let mut paddle: Option<Tile> = None;

        program.set_address(0, 2);

        loop {
            match program.run() {
                Interrupt::WaitingForInput => {
                    let joystick = match (ball, paddle) {
                        (Some(b), Some(p)) if b.position.x < p.position.x => JoystickPosition::Left,
                        (Some(b), Some(p)) if b.position.x > p.position.x => {
                            JoystickPosition::Right
                        }
                        (Some(b), Some(p)) if b.position.x == p.position.x => {
                            JoystickPosition::Neutral
                        }
                        _ => JoystickPosition::Neutral,
                    };
                    program.set_input(joystick as i64)
                }
                Interrupt::Output(o) => {
                    if tile_position_buffer[0] == None {
                        tile_position_buffer[0] = Some(o as i32);
                    } else if tile_position_buffer[1] == None {
                        tile_position_buffer[1] = Some(o as i32);
                    } else if tile_position_buffer[0] == Some(-1)
                        && tile_position_buffer[1] == Some(0)
                    {
                        score = Some(o);
                        tile_position_buffer = [None, None];
                    } else {
                        let tile = Tile {
                            position: Point2::new(
                                tile_position_buffer[0].unwrap(),
                                tile_position_buffer[1].unwrap(),
                            ),
                            id: Identifier::from(o),
                        };
                        match tile.id {
                            Identifier::Paddle => paddle = Some(tile),
                            Identifier::Ball => ball = Some(tile),
                            _ => {}
                        }
                        tile_position_buffer = [None, None];
                    }
                }
                _ => break,
            }
        }
        assert_eq!(score, Some(11991));
    }
}
