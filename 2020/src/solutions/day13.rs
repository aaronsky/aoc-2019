use std::{num::ParseIntError, str::FromStr};

struct BusRoute {
    id: i128,
    in_service: bool,
}

impl BusRoute {
    fn time_to_next_bus(&self, from: i128) -> i128 {
        self.id - (from % self.id)
    }
}

impl FromStr for BusRoute {
    type Err = ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let route = match s {
            "x" => Self {
                id: -1,
                in_service: false,
            },
            id => Self {
                id: i128::from_str(id)?,
                in_service: true,
            },
        };
        Ok(route)
    }
}

pub struct BusSchedule {
    depart_time: i128,
    routes: Vec<BusRoute>,
}

impl BusSchedule {
    pub fn soonest_bus_wait(&self) -> (i128, i128) {
        let (i, wait) = self
            .routes
            .iter()
            .enumerate()
            .filter(|(_, r)| r.in_service)
            .map(|(i, route)| (i, route.time_to_next_bus(self.depart_time)))
            .min_by(|lhs, rhs| lhs.1.cmp(&rhs.1))
            .unwrap();
        (self.routes[i].id, wait)
    }

    pub fn soonest_timestamp_constrained(&self) -> Option<i128> {
        let (residues, modulii) = self
            .routes
            .iter()
            .enumerate()
            .filter(|(_, route)| route.in_service)
            .map(|(i, route)| (i as i128, route.id))
            .unzip::<_, _, Vec<_>, Vec<_>>();

        Some(modulii.iter().product::<i128>() - util::chinese_remainder(&residues, &modulii)?)
    }
}

impl FromStr for BusSchedule {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut lines = s.lines();
        let (depart_raw, routes_raw) = (lines.next().ok_or(())?, lines.next().ok_or(())?);
        let depart_time = FromStr::from_str(depart_raw).map_err(|_| ())?;
        let routes = routes_raw
            .split(',')
            .map(FromStr::from_str)
            .filter_map(Result::ok)
            .collect();

        Ok(Self {
            depart_time,
            routes,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let input: BusSchedule = util::Input::new("day13.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        let (id, wait) = input.soonest_bus_wait();
        assert_eq!(id * wait, 5946);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let input: BusSchedule = util::Input::new("day13.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        let timestamp = input.soonest_timestamp_constrained();
        assert_eq!(timestamp, Some(645338524823718));
    }
}
