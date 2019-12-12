use crate::util::{FloatDistance, Point2, TAU};
use std::cmp;
use std::collections::HashMap;
use std::ops::Index;

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

#[derive(Debug)]
pub struct Map {
    asteroids: Vec<Point2>,
    width: usize,
    height: usize,
}

impl Map {
    pub fn parse(input: &str) -> Self {
        let mut width = 0;
        let mut height = 0;
        let asteroids: Vec<Point2> = input
            .split('\n')
            .enumerate()
            .map(|(y, row)| {
                height = cmp::max(y, height);
                let rows: Vec<Point2> = row
                    .chars()
                    .enumerate()
                    .flat_map(|(x, coord)| match Body::from(coord) {
                        Body::Asteroid => Some(Point2 {
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

    pub fn asteroid_with_most_other_asteroids_visible(&self) -> (&Point2, u32) {
        let mut max = None;
        for asteroid in &self.asteroids {
            let num_visible = self.number_of_visible_asteroids_from_asteroid(*asteroid);
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

    fn number_of_visible_asteroids_from_asteroid(&self, asteroid: Point2) -> u32 {
        let mut angles = Vec::new();
        for other in &self.asteroids {
            let angle = other.polar_angle_to(asteroid);
            if !angles.contains(&angle) {
                angles.push(angle);
            }
        }
        angles.len() as u32
    }

    pub fn vaporize_asteroids_from_coord(&mut self, coord: Point2) -> Point2 {
        let mut angles: HashMap<FloatDistance, Vec<&Point2>> = Default::default();
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
            .position(|a| *a >= FloatDistance(TAU / 4.0_f64))
            .unwrap();
        let mut most_recently_vaporized = Point2::zero();
        for _ in 0..200 {
            let mut next_angle = sorted_angles[angle_index];
            while angles.get(&next_angle).is_none() || angles.get(&next_angle).unwrap().is_empty() {
                angle_index += 1;
                next_angle = sorted_angles[angle_index];
            }
            let next_asteroids = angles.get_mut(&next_angle).unwrap();
            most_recently_vaporized = *next_asteroids.remove(0);
            angle_index += 1;
            angle_index %= sorted_angles.len();
        }

        most_recently_vaporized
    }
}

impl Index<(usize, usize)> for Map {
    type Output = Point2;

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
        let station = Point2 { x: 20, y: 18 };
        let two_hundreth_asteroid = map.vaporize_asteroids_from_coord(station);
        assert_eq!(
            (two_hundreth_asteroid.x * 100) + two_hundreth_asteroid.y,
            706
        );
    }
}
