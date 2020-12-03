use itertools::Itertools;
use std::str::FromStr;

#[derive(Debug, PartialEq)]
pub enum Tile {
    Space,
    Tree,
}

pub struct Log {
    pub trees_encountered: u32,
}

#[derive(Debug)]
pub struct Map {
    tiles: Vec<Tile>,
    pub width: usize,
    pub height: usize,
}

impl FromStr for Map {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let rows = s.split('\n').collect_vec();
        let height = rows.len();
        let tiles: Vec<Tile> = rows
            .into_iter()
            .flat_map(|r| {
                r.chars().map(|c| match c {
                    '.' => Tile::Space,
                    '#' => Tile::Tree,
                    _ => unreachable!("invalid input"),
                })
            })
            .collect();
        let width = tiles.len() / height;

        assert_eq!(tiles[0], Tile::Space);
        assert_eq!(tiles[11], Tile::Tree);
        assert_eq!(tiles[34], Tile::Tree);

        Ok(Map {
            tiles,
            width,
            height,
        })
    }
}

impl Map {
    pub fn tile(&self, x: usize, y: usize) -> &Tile {
        &self.tiles[self.width * y + (x % self.width)]
    }

    pub fn navigate_with_stride(&self, x_stride: usize, y_stride: usize) -> Log {
        let mut current_x = 0;
        let mut current_y = 0;
        let mut trees = 0;

        while current_y < self.height {
            let tile = self.tile(current_x, current_y);

            if tile == &Tile::Tree {
                trees += 1;
            }

            current_x += x_stride;
            current_y += y_stride;
        }

        Log {
            trees_encountered: trees,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let map: Map = util::load_input_file("day03.txt").unwrap();
        assert_eq!(map.navigate_with_stride(3, 1).trees_encountered, 225);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let map: Map = util::load_input_file("day03.txt").unwrap();
        let product = map.navigate_with_stride(1, 1).trees_encountered
            * map.navigate_with_stride(3, 1).trees_encountered
            * map.navigate_with_stride(5, 1).trees_encountered
            * map.navigate_with_stride(7, 1).trees_encountered
            * map.navigate_with_stride(1, 2).trees_encountered;
        assert_eq!(product, 1115775000);
    }
}
