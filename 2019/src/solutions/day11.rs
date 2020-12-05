use crate::shared::*;
use std::collections::HashMap;
use util::{Direction, Point2};

#[derive(Debug, Clone, Copy)]
pub enum Color {
    Black = 0,
    White = 1,
}

impl From<u8> for Color {
    fn from(input: u8) -> Self {
        match input {
            0 => Color::Black,
            1 => Color::White,
            _ => panic!("unsupported color value"),
        }
    }
}

pub struct Robot {
    position: Point2,
    direction: Direction,
}

impl Robot {
    pub fn navigate_panels(
        &mut self,
        starting_color: Color,
        mut program: Intcode,
    ) -> HashMap<Point2, Color> {
        let mut navigated_panels = HashMap::new();
        let mut panel_wants_color = true;
        navigated_panels.insert(self.position, starting_color);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => program.set_input(
                    *navigated_panels
                        .get(&self.position)
                        .unwrap_or(&Color::Black) as i64,
                ),
                Interrupt::Output(output) => {
                    if panel_wants_color {
                        navigated_panels.insert(self.position, Color::from(output as u8));
                    } else {
                        self.rotate_by(output as u8);
                        self.move_by(1);
                    }
                    panel_wants_color = !panel_wants_color;
                }
                Interrupt::Halted => break,
            };
        }
        navigated_panels
    }

    fn move_by(&mut self, distance: i32) {
        self.position = match self.direction {
            Direction::Up => Point2::new(self.position.x, self.position.y - distance),
            Direction::Down => Point2::new(self.position.x, self.position.y + distance),
            Direction::Left => Point2::new(self.position.x - distance, self.position.y),
            Direction::Right => Point2::new(self.position.x + distance, self.position.y),
        }
    }

    fn rotate_by(&mut self, bit: u8) {
        self.direction = match (self.direction, bit) {
            (Direction::Up, 0) => Direction::Left,
            (Direction::Down, 0) => Direction::Right,
            (Direction::Left, 0) => Direction::Down,
            (Direction::Right, 0) => Direction::Up,
            (Direction::Up, 1) => Direction::Right,
            (Direction::Down, 1) => Direction::Left,
            (Direction::Left, 1) => Direction::Up,
            (Direction::Right, 1) => Direction::Down,
            _ => unreachable!(),
        }
    }
}

impl Default for Robot {
    fn default() -> Self {
        Robot {
            position: Point2::zero(),
            direction: Direction::Up,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    const PART_2_RENDERED: &'static str = "\
.####.####..##..#..#.#..#.####..##...##....
.#....#....#..#.#.#..#..#.#....#..#.#..#...
.###..###..#....##...#..#.###..#....#......
.#....#....#....#.#..#..#.#....#.##.#......
.#....#....#..#.#.#..#..#.#....#..#.#..#...
.####.#.....##..#..#..##..####..###..##....
";

    fn bounds_of_slice(vec: &[i32]) -> (i32, i32) {
        let min = *vec.iter().min().unwrap();
        let max = *vec.iter().max().unwrap();
        (min, max)
    }

    #[test]
    fn test_advent_puzzle_1() {
        let rom = util::load_input_file("day11.txt", crate::YEAR)
            .unwrap()
            .into_vec(",");
        let program = Intcode::new(&rom);
        let mut robot = Robot::default();
        let panels = robot.navigate_panels(Color::Black, program);
        assert_eq!(panels.len(), 2211);
    }

    #[test]
    fn test_advent_puzzle_2() {
        let rom = util::load_input_file("day11.txt", crate::YEAR)
            .unwrap()
            .into_vec(",");
        let program = Intcode::new(&rom);
        let mut robot = Robot::default();
        let panels = robot.navigate_panels(Color::White, program);
        let x_values: Vec<i32> = panels.keys().map(|p| p.x).collect();
        let x_range = bounds_of_slice(&x_values);
        let y_values: Vec<i32> = panels.keys().map(|p| p.y).collect();
        let y_range = bounds_of_slice(&y_values);

        let mut rendered_identifier = String::new();

        for y in y_range.0..=y_range.1 {
            for x in x_range.0..=x_range.1 {
                let panel = panels.get(&Point2::new(x, y)).unwrap_or(&Color::Black);
                let panel_char = match panel {
                    Color::Black => '.',
                    Color::White => '#',
                };
                rendered_identifier.push(panel_char);
            }
            rendered_identifier.push('\n');
        }

        assert_eq!(rendered_identifier, PART_2_RENDERED);
    }
}
