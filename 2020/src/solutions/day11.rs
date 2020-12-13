use std::{fmt::Debug, str::FromStr};
use util::{Matrix, Point2};

const VEC_AXES: [Point2; 8] = [
    Point2::new(-1, -1),
    Point2::new(0, -1),
    Point2::new(1, -1),
    Point2::new(-1, 0),
    Point2::new(1, 0),
    Point2::new(-1, 1),
    Point2::new(0, 1),
    Point2::new(1, 1),
];

#[derive(Debug, PartialEq, Copy, Clone)]
pub enum Seat {
    Floor,
    Empty,
    Occupied,
}

#[derive(PartialEq)]
pub struct Seats {
    grid: Matrix<Seat>,
}

impl Seats {
    pub fn occupied(&self) -> usize {
        self.grid.iter().filter(|s| s == &&Seat::Occupied).count()
    }

    pub fn repopulate(&mut self) -> bool {
        let mut new_state = self.grid.clone();

        for (x, y) in self.grid.positions() {
            match self.grid.get(x, y) {
                Some(Seat::Floor) | None => continue,
                Some(seat @ Seat::Empty) | Some(seat @ Seat::Occupied) => {
                    let adjacent_occupied = self
                        .grid
                        .neighboring_positions(x, y, true)
                        .filter_map(|(x, y)| self.grid.get(x, y).filter(|s| s == &&Seat::Occupied))
                        .count();
                    match seat {
                        Seat::Empty if adjacent_occupied == 0 => {
                            new_state.set(x, y, Seat::Occupied)
                        }
                        Seat::Occupied if adjacent_occupied >= 4 => {
                            new_state.set(x, y, Seat::Empty)
                        }
                        _ => {}
                    }
                }
            }
        }

        let state_did_change = self.grid != new_state;
        self.grid = new_state;

        state_did_change
    }

    pub fn repopulate_line_of_sight(&mut self) -> bool {
        let mut new_state = self.grid.clone();

        for (x, y) in self.grid.positions() {
            match self.grid.get(x, y) {
                None => panic!("invalid position ({}, {})", x, y),
                Some(Seat::Floor) => continue,
                Some(seat @ Seat::Empty) | Some(seat @ Seat::Occupied) => {
                    let around_occupied = VEC_AXES
                        .iter()
                        .filter_map(|axis| self.grid.first(x, y, axis, |s| s != &Seat::Floor))
                        .filter(|s| s == &&Seat::Occupied)
                        .count();
                    match seat {
                        Seat::Empty if around_occupied == 0 => new_state.set(x, y, Seat::Occupied),
                        Seat::Occupied if around_occupied >= 5 => new_state.set(x, y, Seat::Empty),
                        _ => {}
                    }
                }
            }
        }

        let state_did_change = self.grid != new_state;
        self.grid = new_state;

        state_did_change
    }
}

impl FromStr for Seats {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let rows = s.lines().collect::<Vec<_>>();
        let height = rows.len();
        let area = rows
            .into_iter()
            .flat_map(|r| {
                r.chars().map(|c| match c {
                    '.' => Seat::Floor,
                    'L' => Seat::Empty,
                    '#' => Seat::Occupied,
                    _ => unreachable!("invalid input"),
                })
            })
            .collect::<Vec<_>>();
        let width = area.len() / height;
        let mut grid = Matrix::from(area);

        grid.width = width;
        grid.height = height;

        Ok(Self { grid })
    }
}

impl Debug for Seats {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut builder = String::new();
        let mut last_row = 0;

        for (x, y) in self.grid.positions() {
            if last_row != y {
                builder.push('\n');
            }
            last_row = y;
            let seat = match self.grid.get(x, y) {
                Some(Seat::Floor) => '.',
                Some(Seat::Empty) => 'L',
                Some(Seat::Occupied) => '#',
                None => return Err(std::fmt::Error {}),
            };
            builder.push(seat);
        }

        write!(f, "{}", builder)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let mut seats: Seats = util::Input::new("day11.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        while seats.repopulate() {}

        assert_eq!(seats.occupied(), 2344);
    }

    #[test]
    #[ignore = "doesn't work"]
    fn test_advent_puzzle_two() {
        let mut seats: Seats = util::Input::new("day11.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        while seats.repopulate_line_of_sight() {}

        assert_eq!(seats.occupied(), 2076);
    }
}
