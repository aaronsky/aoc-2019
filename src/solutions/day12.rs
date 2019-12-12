use crate::util::Point3;

struct Moon {
    position: Point3,
    velocity: Point3,
}

impl Moon {
    fn new(position: Point3) -> Self {
        Moon {
            position,
            velocity: Point3::default(),
        }
    }

    fn total_energy(&self) -> i32 {
        self.potential_energy() * self.kinetic_energy()
    }

    fn potential_energy(&self) -> i32 {
        self.position.x.abs() + self.position.y.abs() + self.position.z.abs()
    }

    fn kinetic_energy(&self) -> i32 {
        self.velocity.x.abs() + self.velocity.y.abs() + self.velocity.z.abs()
    }
}

impl From<&str> for Moon {
    fn from(point_str: &str) -> Self {
        // <x=-6, y=2, z=-9>
        let point = Point3::zero();
        Moon::new(point)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::util;

    fn parse(input: &str) -> Vec<Moon> {
        input.split('\n').map(From::from).collect()
    }

    #[test]
    fn test_advent_puzzle_1() {
        let input = util::load_input_file("day12.txt", parse).unwrap();
    }
}
