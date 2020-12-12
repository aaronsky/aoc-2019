use std::ops::{Add, AddAssign};

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

    pub const fn is_negative(&self) -> bool {
        self.x.is_negative() || self.y.is_negative()
    }

    pub fn polar_angle_to(self, other: Self) -> f64 {
        let x_diff: f64 = (other.x - self.x) as f64;
        let y_diff: f64 = (other.y - self.y) as f64;

        f64::atan2(y_diff, x_diff)
    }

    pub fn manhattan_distance(self, to: Self) -> i32 {
        i32::abs(self.x - to.x) + i32::abs(self.y - to.y)
    }
}

impl Default for Point2 {
    fn default() -> Self {
        Point2::zero()
    }
}

impl Add for Point2 {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}

impl Add<&Self> for Point2 {
    type Output = Self;

    fn add(self, rhs: &Self) -> Self::Output {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
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
