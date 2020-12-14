mod point;

pub use point::*;

use std::cmp::{Eq, Ord, Ordering, PartialEq, PartialOrd};
use std::f64;
use std::hash::{Hash, Hasher};

pub const TAU: f64 = f64::consts::PI * 2.0;

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

pub fn chinese_remainder(residues: &[i64], modulii: &[i64]) -> Option<i64> {
    let product = modulii.iter().product::<i64>();
    let mut sum = 0;

    for (&residue, &modulus) in residues.iter().zip(modulii) {
        let inv = product / modulus;
        sum += residue * inverse_mod(inv, modulus)? * inv;
    }

    Some(sum % product)
}

fn inverse_mod(x: i64, n: i64) -> Option<i64> {
    let (g, x, _) = extended_gcd(x, n);
    if g == 1 {
        return Some((x % n + n) % n);
    }
    None
}

#[allow(clippy::many_single_char_names)]
fn extended_gcd(a: i64, b: i64) -> (i64, i64, i64) {
    if a == 0 {
        return (b, 0, 1);
    }
    let (g, x, y) = extended_gcd(b % a, a);
    (g, y - (b / a) * x, x)
}

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
