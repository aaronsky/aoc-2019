use std::{convert::TryInto, ops::Add, str::FromStr};

type Position = (usize, usize);

#[derive(Debug)]
pub struct Point {
    x: isize,
    y: isize,
}

impl Point {
    pub const fn new(x: isize, y: isize) -> Self {
        Self { x, y }
    }

    pub const fn is_negative(&self) -> bool {
        self.x.is_negative() || self.y.is_negative()
    }
}

impl Add for Point {
    type Output = Point;

    fn add(self, rhs: Self) -> Self::Output {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}

impl Add<&Self> for Point {
    type Output = Point;

    fn add(self, rhs: &Self) -> Self::Output {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}

const VEC_AXES: [Point; 8] = [
    Point::new(-1, -1),
    Point::new(0, -1),
    Point::new(1, -1),
    Point::new(-1, 0),
    Point::new(1, 0),
    Point::new(-1, 1),
    Point::new(0, 1),
    Point::new(1, 1),
];

#[derive(Debug, PartialEq, Clone)]
pub struct Matrix<N> {
    elements: Vec<N>,
    width: usize,
    height: usize,
}

impl<N> Matrix<N> {
    pub fn get(&self, x: usize, y: usize) -> Option<&N> {
        self.elements.get(self.index(x, y))
    }

    pub fn get_mut(&mut self, x: usize, y: usize) -> Option<&mut N> {
        let index = self.index(x, y);
        self.elements.get_mut(index)
    }

    pub fn set(&mut self, x: usize, y: usize, value: N) {
        if let Some(x) = self.get_mut(x, y) {
            *x = value
        }
    }

    pub fn index(&self, x: usize, y: usize) -> usize {
        self.width * y + x
    }

    pub fn position(&self, index: usize) -> Position {
        let x = index % self.width;
        let y = index / self.width;

        (x, y)
    }

    pub fn iter(&self) -> impl Iterator<Item = &N> {
        self.elements.iter()
    }

    pub fn positions(&self) -> impl Iterator<Item = Position> + '_ {
        (0..self.elements.len()).map(move |i| self.position(i))
    }

    pub fn neighboring_positions(
        &self,
        x: usize,
        y: usize,
        diagonals: bool,
    ) -> impl Iterator<Item = Position> {
        let mut neighbors = vec![];
        let (top, right, bottom, left) =
            (y == 0, x + 1 >= self.width, y + 1 >= self.height, x == 0);

        if !top {
            neighbors.push((x, y - 1));
        }
        if !right {
            neighbors.push((x + 1, y));
        }
        if !bottom {
            neighbors.push((x, y + 1));
        }
        if !left {
            neighbors.push((x - 1, y));
        }

        if diagonals {
            if !left && !top {
                neighbors.push((x - 1, y - 1));
            }
            if !left && !bottom {
                neighbors.push((x - 1, y + 1));
            }
            if !right && !top {
                neighbors.push((x + 1, y - 1));
            }
            if !right && !bottom {
                neighbors.push((x + 1, y + 1));
            }
        }

        neighbors.into_iter()
    }

    pub fn first<F>(&self, x: usize, y: usize, along: &Point, matches: F) -> Option<&N>
    where
        F: Fn(&N) -> bool,
    {
        let mut p = Point::new(x.try_into().unwrap(), y.try_into().unwrap()) + along;
        if p.is_negative() {
            return None;
        }

        while let Some(el) = self.get(p.x.try_into().unwrap(), p.y.try_into().unwrap()) {
            if matches(el) {
                return Some(el);
            }

            p = p + along;
            if p.is_negative() {
                return None;
            }
        }

        None
    }
}

impl<N> Default for Matrix<N> {
    fn default() -> Self {
        Self {
            elements: vec![],
            width: 0,
            height: 0,
        }
    }
}

impl<N> From<Vec<N>> for Matrix<N>
where
    N: Clone,
{
    fn from(elements: Vec<N>) -> Self {
        Self {
            elements,
            ..Default::default()
        }
    }
}

impl<N> IntoIterator for Matrix<N> {
    type Item = N;
    type IntoIter = std::vec::IntoIter<N>;

    fn into_iter(self) -> Self::IntoIter {
        self.elements.into_iter()
    }
}

#[derive(Debug, PartialEq, Copy, Clone)]
pub enum Seat {
    Floor,
    Empty,
    Occupied,
}

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
                        .filter_map(|axis| {
                            self.grid
                                .first(x, y, axis, |s| s != &Seat::Floor)
                                .filter(|s| s == &&Seat::Occupied)
                        })
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
    fn test_advent_puzzle_two() {
        let mut seats: Seats = util::Input::new("day11.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        while seats.repopulate_line_of_sight() {}

        assert_eq!(seats.occupied(), 2076);
    }
}
