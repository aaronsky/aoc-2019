use std::cmp::{Eq, Ord, Ordering, PartialEq, PartialOrd};
use std::f64;
use std::hash::{Hash, Hasher};
use std::mem;

pub fn number_of_digits(num: f64) -> f64 {
    f64::floor(f64::log10(num) + 1.0)
}

pub fn digit_at_index(index: u32, num: u32) -> u8 {
    let mask = u32::pow(10, index);
    ((num / mask) % 10) as u8
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Point2 {
    pub x: i32,
    pub y: i32,
}

impl Point2 {
    pub fn new(x: i32, y: i32) -> Self {
        Point2 { x, y }
    }

    pub fn zero() -> Self {
        Point2::new(0, 0)
    }

    pub fn polar_angle_to(self, other: Point2) -> f64 {
        let x_diff: f64 = (other.x - self.x) as f64;
        let y_diff: f64 = (other.y - self.y) as f64;
        f64::atan2(y_diff, x_diff)
    }

    pub fn manhattan_distance(self, to: Point2) -> i32 {
        i32::abs(self.x - to.x) + i32::abs(self.y - to.y)
    }
}

impl Default for Point2 {
    fn default() -> Self {
        Point2::zero()
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Point3 {
    pub x: i32,
    pub y: i32,
    pub z: i32,
}

impl Point3 {
    pub fn new(x: i32, y: i32, z: i32) -> Self {
        Point3 { x, y, z }
    }

    pub fn zero() -> Self {
        Point3::new(0, 0, 0)
    }
}

impl Default for Point3 {
    fn default() -> Self {
        Point3::zero()
    }
}

#[derive(Debug, Clone, Copy)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

pub const TAU: f64 = f64::consts::PI * 2.0;

/// Use at your own risk
#[derive(Debug, Copy, Clone)]
pub struct FloatDistance(pub f64);

impl FloatDistance {
    fn key(self) -> u64 {
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
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        if self.key() == other.key() {
            Some(Ordering::Equal)
        } else if self.key() < other.key() {
            Some(Ordering::Less)
        } else if self.key() > other.key() {
            Some(Ordering::Greater)
        } else {
            None
        }
    }
}

impl Eq for FloatDistance {}

impl Ord for FloatDistance {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}
