use std::str::FromStr;

#[derive(Debug)]
pub enum Action {
    On,
    Off,
    Toggle,
}

#[derive(Debug)]
pub struct Instruction {
    action: Action,
    start: (usize, usize),
    end: (usize, usize),
}

impl FromStr for Instruction {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let coords_str: &str;
        let action = if let Some(c) = s.strip_prefix("turn on") {
            coords_str = c.trim();
            Action::On
        } else if let Some(c) = s.strip_prefix("turn off") {
            coords_str = c.trim();
            Action::Off
        } else if let Some(c) = s.strip_prefix("toggle") {
            coords_str = c.trim();
            Action::Toggle
        } else {
            return Err(());
        };
        let coords: Vec<&str> = coords_str.split("through").map(str::trim).take(2).collect();

        let (start_str, end_str) = (coords[0], coords[1]);

        let start_comps: Vec<usize> = start_str
            .split(',')
            .take(2)
            .map(usize::from_str)
            .filter_map(Result::ok)
            .collect();
        let start = (start_comps[0], start_comps[1]);

        let end_comps: Vec<usize> = end_str
            .split(',')
            .take(2)
            .map(usize::from_str)
            .filter_map(Result::ok)
            .collect();
        let end = (end_comps[0], end_comps[1]);

        Ok(Instruction { action, start, end })
    }
}

#[derive(Debug)]
pub enum Mode {
    OnOff,
    Brightness,
}

#[derive(Debug)]
pub struct LightBoard {
    lights: [u8; 1_000_000],
    mode: Mode,
}

impl LightBoard {
    pub fn new(mode: Mode) -> Self {
        LightBoard {
            lights: [0; 1_000_000],
            mode,
        }
    }

    pub fn total_on(&self) -> usize {
        self.lights.iter().filter(|l| **l > 0).count()
    }

    pub fn total_brightness(&self) -> usize {
        self.lights.iter().map(|l| *l as usize).sum()
    }

    pub fn apply_instructions(&mut self, instructions: &[Instruction]) {
        for i in instructions {
            for x in i.start.0..=i.end.0 {
                for y in i.start.1..=i.end.1 {
                    self.action(&i.action, x, y);
                }
            }
        }
    }

    fn action(&mut self, action: &Action, x: usize, y: usize) {
        let pos = LightBoard::index(x, y);

        match self.mode {
            Mode::OnOff => {
                self.lights[pos] = match action {
                    Action::On => 1,
                    Action::Off => 0,
                    Action::Toggle => 1 - self.lights[pos],
                }
            }
            Mode::Brightness => {
                self.lights[pos] = match action {
                    Action::On => self.lights[pos] + 1,
                    Action::Off => {
                        if let Some(diff) = self.lights[pos].checked_sub(1) {
                            diff
                        } else {
                            0
                        }
                    }
                    Action::Toggle => self.lights[pos] + 2,
                }
            }
        }
    }

    fn index(x: usize, y: usize) -> usize {
        1000 * x + y
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let instructions = util::Input::new("day06.txt", crate::YEAR)
            .unwrap()
            .to_vec::<Instruction>("\n");
        let mut lights = LightBoard::new(Mode::OnOff);

        lights.apply_instructions(&instructions);
        assert_eq!(lights.total_on(), 569999);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let instructions = util::Input::new("day06.txt", crate::YEAR)
            .unwrap()
            .to_vec::<Instruction>("\n");
        let mut lights = LightBoard::new(Mode::Brightness);

        lights.apply_instructions(&instructions);
        assert_eq!(lights.total_brightness(), 17836115);
    }
}
