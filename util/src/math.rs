use std::cmp::{Eq, Ord, Ordering, PartialEq, PartialOrd};
use std::f64;
use std::hash::{Hash, Hasher};
use std::ops::{Add, AddAssign};

pub fn number_of_digits(num: f64) -> f64 {
    f64::floor(f64::log10(num) + 1.0)
}

pub fn digit_at_index(index: u32, num: u32) -> u8 {
    let mask = u32::pow(10, index);
    ((num / mask) % 10) as u8
}

pub fn gcd(num1: i64, num2: i64) -> i64 {
    // Use Stein's algorithm
    let mut m = num1;
    let mut n = num2;
    if m == 0 || n == 0 {
        return (m | n).abs();
    }

    let shift = (m | n).trailing_zeros();
    if m == i64::min_value() || n == i64::min_value() {
        let shifted: i64 = 1 << shift;
        return shifted.abs();
    }

    m = m.abs();
    n = n.abs();

    m >>= m.trailing_zeros();
    n >>= n.trailing_zeros();

    while m != n {
        if m > n {
            m -= n;
            m >>= m.trailing_zeros();
        } else {
            n -= m;
            n >>= n.trailing_zeros();
        }
    }
    m << shift
}

pub fn lcm(num1: i64, num2: i64) -> i64 {
    if num1 == 0 && num2 == 0 {
        return 0;
    }
    num1 * (num2 / gcd(num1, num2))
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Point2 {
    pub x: i32,
    pub y: i32,
}

impl Point2 {
    pub const fn new(x: i32, y: i32) -> Self {
        Self { x, y }
    }

    pub const fn zero() -> Self {
        Self::new(0, 0)
    }

    pub fn polar_angle_to(self, other: Point2) -> f64 {
        let x_diff: f64 = (other.x - self.x) as f64;
        let y_diff: f64 = (other.y - self.y) as f64;
        f64::atan2(y_diff, x_diff)
    }

    pub fn manhattan_distance(self, to: Point2) -> i32 {
        i32::abs(self.x - to.x) + i32::abs(self.y - to.y)
    }

    pub fn move_in_direction(&mut self, direction: Direction) {
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

impl Add for Point3 {
    type Output = Point3;

    fn add(self, rhs: Self) -> Self::Output {
        Point3::new(self.x + rhs.x, self.y + rhs.y, self.z + rhs.z)
    }
}

impl AddAssign for Point3 {
    fn add_assign(&mut self, other: Self) {
        self.x += other.x;
        self.y += other.y;
        self.z += other.z;
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
        self.0.to_bits()
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
        self.key().eq(&other.key())
    }
}

impl PartialOrd for FloatDistance {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.key().cmp(&other.key()))
    }
}

impl Eq for FloatDistance {}

impl Ord for FloatDistance {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}
