use std::cmp;
use std::collections::HashMap;
use std::f64;
use std::hash::{Hash, Hasher};
use std::mem;
use std::ops::Index;

const TAU: f64 = f64::consts::PI * 2.0;

#[derive(Debug, Copy, Clone)]
struct FloatDistance(f64);

impl FloatDistance {
    fn key(&self) -> u64 {
        unsafe { mem::transmute(self.0) }
    }
}

impl Hash for FloatDistance {
    fn hash<H>(&self, state: &mut H)
    where
        H: Hasher,
    {
        self.key().hash(state)
    }
}

impl PartialEq for FloatDistance {
    fn eq(&self, other: &FloatDistance) -> bool {
        self.key() == other.key()
    }
}

impl PartialOrd for FloatDistance {
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        if self.key() == other.key() {
            Some(cmp::Ordering::Equal)
        } else if self.key() < other.key() {
            Some(cmp::Ordering::Less)
        } else if self.key() > other.key() {
            Some(cmp::Ordering::Greater)
        } else {
            None
        }
    }
}

impl Eq for FloatDistance {}

impl Ord for FloatDistance {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        self.partial_cmp(other).unwrap()
    }
}

#[derive(Debug)]
enum Body {
    Space,
    Asteroid,
}

impl From<char> for Body {
    fn from(c: char) -> Self {
        match c {
            '.' => Body::Space,
            '#' => Body::Asteroid,
            _ => panic!("unsupported celestial body {}", c),
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub struct Coordinate {
    x: i32,
    y: i32,
}

impl Coordinate {
    fn zero() -> Self {
        Coordinate { x: 0, y: 0 }
    }

    fn polar_angle_to(&self, other: &Coordinate) -> f64 {
        let x_diff: f64 = (other.x - self.x) as f64;
        let y_diff: f64 = (other.y - self.y) as f64;
        f64::atan2(y_diff, x_diff)
    }

    pub fn manhattan_distance(&self, to: &Coordinate) -> i32 {
        i32::abs(self.x - to.x) + i32::abs(self.y - to.y)
    }
}

#[derive(Debug)]
pub struct Map {
    asteroids: Vec<Coordinate>,
    width: usize,
    height: usize,
}

impl Map {
    pub fn parse(input: &str) -> Self {
        let mut width = 0;
        let mut height = 0;
        let asteroids: Vec<Coordinate> = input
            .split('\n')
            .enumerate()
            .map(|(y, row)| {
                height = cmp::max(y, height);
                let rows: Vec<Coordinate> = row
                    .chars()
                    .enumerate()
                    .flat_map(|(x, coord)| match Body::from(coord) {
                        Body::Asteroid => Some(Coordinate {
                            x: x as i32,
                            y: y as i32,
                        }),
                        _ => None,
                    })
                    .collect();
                width = cmp::max(rows.len(), width);
                rows
            })
            .flatten()
            .collect();
        Map {
            asteroids,
            width,
            height,
        }
    }

    pub fn asteroid_with_most_other_asteroids_visible(&self) -> (&Coordinate, u32) {
        let mut max = None;
        for asteroid in &self.asteroids {
            let num_visible = self.number_of_visible_asteroids_from_asteroid(&asteroid);
            if let Some((_, visible)) = max {
                if num_visible > visible {
                    max = Some((asteroid, num_visible));
                }
            } else {
                max = Some((asteroid, num_visible));
            }
        }
        max.unwrap()
    }

    fn number_of_visible_asteroids_from_asteroid(&self, asteroid: &Coordinate) -> u32 {
        let mut angles = Vec::new();
        for other in &self.asteroids {
            let angle = other.polar_angle_to(asteroid);
            if !angles.contains(&angle) {
                angles.push(angle);
            }
        }
        angles.len() as u32
    }

    pub fn vaporize_asteroids_from_coord(&mut self, coord: &Coordinate) -> Coordinate {
        let mut angles: HashMap<FloatDistance, Vec<&Coordinate>> = Default::default();
        for asteroid in &self.asteroids {
            let angle = FloatDistance((asteroid.polar_angle_to(coord) + TAU).rem_euclid(TAU));
            if let Some(mut a) = angles.remove(&angle) {
                a.push(asteroid);
                angles.insert(angle, a);
            } else {
                angles.insert(angle, vec![asteroid]);
            }
        }
        let mut sorted_angles: Vec<FloatDistance> = vec![];
        for (angle, asteroids) in &mut angles {
            sorted_angles.push(angle.clone());
            asteroids.sort_by(|a, b| {
                a.manhattan_distance(coord)
                    .cmp(&b.manhattan_distance(coord))
            })
        }
        sorted_angles.sort();
        let mut angle_index = sorted_angles
            .iter()
            .position(|a| a >= &FloatDistance(TAU / 4.0_f64))
            .unwrap();
        let mut most_recently_vaporized = Coordinate::zero();
        for _ in 0..200 {
            let mut next_angle = sorted_angles[angle_index];
            while angles.get(&next_angle).is_none() || angles.get(&next_angle).unwrap().is_empty() {
                angle_index += 1;
                next_angle = sorted_angles[angle_index];
            }
            let next_asteroids = angles.get_mut(&next_angle).unwrap();
            most_recently_vaporized = *next_asteroids.remove(0);
            angle_index += 1;
            angle_index = angle_index % sorted_angles.len();
        }

        most_recently_vaporized
    }
}

impl Index<(usize, usize)> for Map {
    type Output = Coordinate;

    fn index(&self, index: (usize, usize)) -> &Self::Output {
        &self.asteroids[self.width * index.0 + index.1]
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::util;

    #[test]
    fn test_advent_puzzle_1() {
        let map = util::load_input_file("day10.txt", Map::parse).unwrap();
        assert_eq!(map.asteroid_with_most_other_asteroids_visible().1, 280);
    }

    #[test]
    fn test_advent_puzzle_2() {
        let mut map = util::load_input_file("day10.txt", Map::parse).unwrap();
        let station = Coordinate { x: 20, y: 18 };
        let two_hundreth_asteroid = map.vaporize_asteroids_from_coord(&station);
        assert_eq!(
            (two_hundreth_asteroid.x * 100) + two_hundreth_asteroid.y,
            706
        );
    }
}
