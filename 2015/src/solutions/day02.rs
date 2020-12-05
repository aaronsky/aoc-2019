use std::{cmp::min, str::FromStr};

pub struct Present {
    pub width: u32,
    pub height: u32,
    pub length: u32,
}

impl Present {
    pub fn surface_area(&self) -> u32 {
        let lw = self.length * self.width;
        let wh = self.width * self.height;
        let hl = self.height * self.length;
        let smallest_side = min(lw, min(wh, hl));

        2 * lw + 2 * wh + 2 * hl + smallest_side
    }

    pub fn ribbon_length(&self) -> u32 {
        let lw = 2 * self.length + 2 * self.width;
        let wh = 2 * self.width + 2 * self.height;
        let hl = 2 * self.height + 2 * self.length;

        let smallest_side = min(lw, min(wh, hl));
        let volume = self.length * self.width * self.height;

        smallest_side + volume
    }
}

impl FromStr for Present {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let dimensions = s
            .split('x')
            .take(3)
            .map(str::parse::<u32>)
            .filter_map(Result::ok)
            .collect::<Vec<u32>>();

        let (length, width, height) = (dimensions[0], dimensions[1], dimensions[2]);

        Ok(Present {
            width,
            height,
            length,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let presents = util::Input::new("day02.txt", crate::YEAR)
            .unwrap()
            .to_vec("\n");

        let total_surface_area: u32 = presents.iter().map(Present::surface_area).sum();
        assert_eq!(total_surface_area, 1598415);

        let total_ribbon_length: u32 = presents.iter().map(Present::ribbon_length).sum();
        assert_eq!(total_ribbon_length, 3812909);
    }
}
