use std::{
    ops::{Add, AddAssign, Sub, SubAssign},
    str::FromStr,
};

use util::Point2;

#[derive(Debug, Copy, Clone, PartialEq)]
enum Direction {
    North,
    South,
    East,
    West,
    Left,
    Right,
    Forward,
}

impl Direction {
    const fn from_cardinal(deg: i32) -> Self {
        match deg {
            0..=89 | -360..=-271 => Direction::East,
            90..=179 | -270..=-181 => Direction::North,
            180..=269 | -180..=-91 => Direction::West,
            270..=360 | -90..=1 => Direction::South,
            // edge case
            i32::MIN..=-361 | 361..=i32::MAX => Direction::East,
        }
    }

    const fn cardinal(&self) -> i32 {
        match self {
            Direction::East => 0,
            Direction::North => 90,
            Direction::West => 180,
            Direction::South => 270,
            _ => 0,
        }
    }
}

impl Add<i32> for Direction {
    type Output = Self;

    fn add(self, rhs: i32) -> Self::Output {
        Self::from_cardinal((self.cardinal() + rhs) % 360)
    }
}

impl AddAssign<i32> for Direction {
    fn add_assign(&mut self, rhs: i32) {
        *self = self.add(rhs);
    }
}

impl Sub<i32> for Direction {
    type Output = Self;

    fn sub(self, rhs: i32) -> Self::Output {
        Self::from_cardinal((self.cardinal() - rhs) % 360)
    }
}

impl SubAssign<i32> for Direction {
    fn sub_assign(&mut self, rhs: i32) {
        *self = self.sub(rhs);
    }
}

pub struct Instruction {
    direction: Direction,
    value: i32,
}

impl FromStr for Instruction {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (raw_dir, raw_val) = s.split_at(1);
        let direction = match raw_dir {
            "N" => Direction::North,
            "S" => Direction::South,
            "E" => Direction::East,
            "W" => Direction::West,
            "L" => Direction::Left,
            "R" => Direction::Right,
            "F" => Direction::Forward,
            _ => return Err(()),
        };
        let value = FromStr::from_str(raw_val).map_err(|_| ())?;

        Ok(Self { direction, value })
    }
}

pub struct ShipNav {
    instructions: Vec<Instruction>,
    direction: Direction,
    position: Point2,
    waypoint_position: Point2,
}

impl ShipNav {
    pub fn navigate(&mut self) {
        for instruction in &self.instructions {
            match instruction.direction {
                Direction::North => {
                    self.position.y += instruction.value;
                }
                Direction::South => {
                    self.position.y -= instruction.value;
                }
                Direction::East => {
                    self.position.x += instruction.value;
                }
                Direction::West => {
                    self.position.x -= instruction.value;
                }
                Direction::Left => {
                    self.direction += instruction.value;
                }
                Direction::Right => {
                    self.direction -= instruction.value;
                }
                Direction::Forward => match self.direction {
                    Direction::North => {
                        self.position.y += instruction.value;
                    }
                    Direction::South => {
                        self.position.y -= instruction.value;
                    }
                    Direction::East => {
                        self.position.x += instruction.value;
                    }
                    Direction::West => {
                        self.position.x -= instruction.value;
                    }
                    _ => {}
                },
            }
        }
    }

    pub fn navigate_waypoint(&mut self) {
        for instruction in &self.instructions {
            match instruction.direction {
                Direction::North => {
                    self.waypoint_position.y += instruction.value;
                }
                Direction::South => {
                    self.waypoint_position.y -= instruction.value;
                }
                Direction::East => {
                    self.waypoint_position.x += instruction.value;
                }
                Direction::West => {
                    self.waypoint_position.x -= instruction.value;
                }
                Direction::Left => {
                    self.waypoint_position = match instruction.value {
                        90 => Point2::new(-self.waypoint_position.y, self.waypoint_position.x),
                        180 => Point2::new(-self.waypoint_position.x, -self.waypoint_position.y),
                        270 => Point2::new(self.waypoint_position.y, -self.waypoint_position.x),
                        _ => self.waypoint_position,
                    };
                }
                Direction::Right => {
                    self.waypoint_position = match instruction.value {
                        90 => Point2::new(self.waypoint_position.y, -self.waypoint_position.x),
                        180 => Point2::new(-self.waypoint_position.x, -self.waypoint_position.y),
                        270 => Point2::new(-self.waypoint_position.y, self.waypoint_position.x),
                        _ => self.waypoint_position,
                    };
                }
                Direction::Forward => {
                    self.position.x =
                        self.position.x + instruction.value * self.waypoint_position.x;
                    self.position.y =
                        self.position.y + instruction.value * self.waypoint_position.y;
                }
            }
        }
    }
}

impl FromStr for ShipNav {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let instructions = s
            .lines()
            .map(Instruction::from_str)
            .filter_map(Result::ok)
            .collect::<Vec<_>>();

        Ok(Self {
            instructions,
            direction: Direction::East,
            position: Point2::new(0, 0),
            waypoint_position: Point2::new(10, 1),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let mut nav: ShipNav = util::Input::new("day12.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        nav.navigate();
        assert_eq!(nav.position.manhattan_distance(Point2::zero()), 521);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let mut nav: ShipNav = util::Input::new("day12.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        nav.navigate_waypoint();
        assert_eq!(nav.position.manhattan_distance(Point2::zero()), 22848);
    }
}
