use crate::util::{Direction, Point2};
use std::iter;
use std::str::FromStr;

impl Point2 {
    fn move_in_direction(&mut self, direction: Direction) {
        self.x += match direction {
            Direction::Right => 1,
            Direction::Left => -1,
            _ => 0,
        };
        self.y += match direction {
            Direction::Up => 1,
            Direction::Down => -1,
            _ => 0,
        }
    }
}

#[derive(Debug)]
struct Node {
    direction: Direction,
    len: u32,
}

impl Node {
    fn parse(string: &str) -> Self {
        let direction = match string.chars().next() {
            Some('U') => Direction::Up,
            Some('D') => Direction::Down,
            Some('L') => Direction::Left,
            Some('R') => Direction::Right,
            _ => panic!("bad direction"),
        };
        let len = string[1..].parse::<u32>().unwrap();
        Node { direction, len }
    }
}

#[derive(Debug)]
pub struct Wire {
    nodes: Vec<Node>,
}

impl FromStr for Wire {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let nodes: Vec<Node> = s.split(',').map(Node::parse).collect();
        Ok(Wire { nodes })
    }
}

impl Wire {
    pub fn iter(&self) -> impl Iterator<Item = Point2> + '_ {
        self.nodes
            .iter()
            .flat_map(|node| iter::repeat(node.direction).take(node.len as usize))
            .scan(Point2::default(), |cursor, direction| {
                cursor.move_in_direction(direction);
                Some(*cursor)
            })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::util;
    use std::collections::HashMap;

    fn parse_wires(input: &str) -> (Wire, Wire) {
        let mut wires: Vec<Wire> = input
            .split("\n")
            .take(2)
            .map(Wire::from_str)
            .filter_map(Result::ok)
            .collect();
        assert_eq!(wires.len(), 2);
        (wires.remove(0), wires.remove(0))
    }

    #[test]
    fn test_advent_puzzle() {
        let wires_str: String = util::load_input_file("day03.txt").unwrap();
        let (first_wire, second_wire): (Wire, Wire) = parse_wires(&wires_str);
        let first_wire_path: HashMap<_, u32> = first_wire.iter().zip(1..).collect();
        let distance = second_wire
            .iter()
            .zip(1..)
            .filter_map(|(cursor, idx)| first_wire_path.get(&cursor).map(|m| idx + m))
            .min()
            .unwrap();
        assert_eq!(distance, 5672);
    }
}
