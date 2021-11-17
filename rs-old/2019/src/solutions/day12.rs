use std::str::FromStr;
use util::{lcm, Point3};

#[derive(Debug, Clone)]
pub struct Moon {
    pub position: Point3,
    pub velocity: Point3,
}

impl Moon {
    pub fn new(position: Point3) -> Self {
        Moon {
            position,
            velocity: Point3::default(),
        }
    }

    pub fn step(&mut self) {
        self.position += self.velocity;
    }

    pub fn apply_gravity(&mut self, other: &Moon) {
        self.velocity += Point3::new(
            (other.position.x - self.position.x).signum(),
            (other.position.y - self.position.y).signum(),
            (other.position.z - self.position.z).signum(),
        );
    }

    pub fn total_energy(&self) -> i32 {
        self.potential_energy() * self.kinetic_energy()
    }

    pub fn potential_energy(&self) -> i32 {
        self.position.x.abs() + self.position.y.abs() + self.position.z.abs()
    }

    pub fn kinetic_energy(&self) -> i32 {
        self.velocity.x.abs() + self.velocity.y.abs() + self.velocity.z.abs()
    }

    pub fn equals_x(&self, other: &Moon) -> bool {
        self.position.x == other.position.x && self.velocity.x == other.velocity.x
    }

    pub fn equals_y(&self, other: &Moon) -> bool {
        self.position.y == other.position.y && self.velocity.y == other.velocity.y
    }

    pub fn equals_z(&self, other: &Moon) -> bool {
        self.position.z == other.position.z && self.velocity.z == other.velocity.z
    }
}

impl From<&str> for Moon {
    fn from(point_str: &str) -> Self {
        let components: Vec<i32> = point_str
            .replace('<', "")
            .replace('>', "")
            .split(',')
            .flat_map(|component| component.trim().split('=').nth(1).map(str::parse))
            .flat_map(|result| result.ok())
            .take(3)
            .collect();

        if components.len() != 3 {
            Moon::new(Point3::zero())
        } else {
            Moon::new(Point3::new(components[0], components[1], components[2]))
        }
    }
}

#[derive(Debug)]
pub struct LunarSystem {
    pub io: Moon,
    pub europa: Moon,
    pub ganymede: Moon,
    pub callisto: Moon,
    pub step: usize,
}

impl LunarSystem {
    pub fn new(mut moons: Vec<Moon>) -> Self {
        assert_eq!(moons.len(), 4);
        LunarSystem {
            io: moons.remove(0),
            europa: moons.remove(0),
            ganymede: moons.remove(0),
            callisto: moons.remove(0),
            step: 1,
        }
    }

    pub fn simulate<F: FnMut(&mut Self) -> bool>(&mut self, mut should_continue: F) {
        loop {
            self.io.apply_gravity(&self.europa);
            self.io.apply_gravity(&self.ganymede);
            self.io.apply_gravity(&self.callisto);
            self.europa.apply_gravity(&self.io);
            self.europa.apply_gravity(&self.ganymede);
            self.europa.apply_gravity(&self.callisto);
            self.ganymede.apply_gravity(&self.io);
            self.ganymede.apply_gravity(&self.europa);
            self.ganymede.apply_gravity(&self.callisto);
            self.callisto.apply_gravity(&self.io);
            self.callisto.apply_gravity(&self.europa);
            self.callisto.apply_gravity(&self.ganymede);

            self.io.step();
            self.europa.step();
            self.ganymede.step();
            self.callisto.step();

            if !should_continue(self) {
                break;
            }
            self.step += 1;
        }
    }

    pub fn find_minimum_cycles(&mut self) -> usize {
        let initial_io = self.io.clone();
        let initial_europa = self.europa.clone();
        let initial_ganymede = self.ganymede.clone();
        let initial_callisto = self.callisto.clone();
        let mut steps: [Option<i64>; 3] = [None, None, None];
        self.simulate(|system| {
            let mut should_continue = false;
            if steps[0] == None {
                if initial_io.equals_x(&system.io)
                    && initial_europa.equals_x(&system.europa)
                    && initial_ganymede.equals_x(&system.ganymede)
                    && initial_callisto.equals_x(&system.callisto)
                {
                    steps[0] = Some(system.step as i64);
                } else {
                    should_continue |= true;
                }
            }
            if steps[1] == None {
                if initial_io.equals_y(&system.io)
                    && initial_europa.equals_y(&system.europa)
                    && initial_ganymede.equals_y(&system.ganymede)
                    && initial_callisto.equals_y(&system.callisto)
                {
                    steps[1] = Some(system.step as i64);
                } else {
                    should_continue |= true;
                }
            }
            if steps[2] == None {
                if initial_io.equals_z(&system.io)
                    && initial_europa.equals_z(&system.europa)
                    && initial_ganymede.equals_z(&system.ganymede)
                    && initial_callisto.equals_z(&system.callisto)
                {
                    steps[2] = Some(system.step as i64);
                } else {
                    should_continue |= true;
                }
            }
            should_continue
        });
        lcm(lcm(steps[0].unwrap(), steps[1].unwrap()), steps[2].unwrap()) as usize
    }

    pub fn energy_in_system(&self) -> i32 {
        self.io.total_energy()
            + self.europa.total_energy()
            + self.ganymede.total_energy()
            + self.callisto.total_energy()
    }
}

impl FromStr for LunarSystem {
    type Err = ();

    fn from_str(input: &str) -> Result<Self, Self::Err> {
        let moons = input.split('\n').map(From::from).collect();
        Ok(LunarSystem::new(moons))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_1() {
        let mut system: LunarSystem = util::Input::new("day12.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        system.simulate(|system| system.step < 1000);
        assert_eq!(system.energy_in_system(), 14907);
    }

    #[test]
    fn test_advent_puzzle_2() {
        let mut system: LunarSystem = util::Input::new("day12.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        assert_eq!(system.find_minimum_cycles(), 467_081_194_429_464);
    }

    #[test]
    fn smoke_simple_program_1() {
        let mut system = LunarSystem::new(vec![
            Moon::new(Point3::new(-1, 0, 2)),
            Moon::new(Point3::new(2, -10, -7)),
            Moon::new(Point3::new(4, -8, 8)),
            Moon::new(Point3::new(3, 5, -1)),
        ]);
        system.simulate(|system| system.step < 10);
        assert_eq!(system.energy_in_system(), 179);
    }

    #[test]
    fn smoke_simple_program_2() {
        let mut system = LunarSystem::new(vec![
            Moon::new(Point3::new(-8, -10, 0)),
            Moon::new(Point3::new(5, 5, 10)),
            Moon::new(Point3::new(2, -7, 3)),
            Moon::new(Point3::new(9, -8, -3)),
        ]);
        system.simulate(|system| system.step < 100);
        assert_eq!(system.energy_in_system(), 1940);
    }
}
