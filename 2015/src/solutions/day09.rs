use std::cmp;
use std::rc::Rc;
use std::str::FromStr;
use util::{AdjacencyList, Graph};

pub struct Chart {
    graph: AdjacencyList<String>,
}

#[derive(Debug, PartialEq, Eq)]
pub struct Route {
    order: Vec<String>,
    cost: u32,
}

impl cmp::PartialOrd for Route {
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        self.cost.partial_cmp(&other.cost)
    }
}

impl cmp::Ord for Route {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        self.cost.cmp(&other.cost)
    }
}

impl Chart {
    pub fn inspect(&self) {
        println!("{:?}", self.graph);
    }

    pub fn shortest_route(&self) -> Option<Route> {
        let mut route = None;
        for (start, _) in self.graph.iter() {
            let route_from_start = self.shortest_route_from_start(&start);
            if route_from_start < route {
                route = route_from_start;
            }
        }
        route
    }

    fn shortest_route_from_start(&self, _start: &str) -> Option<Route> {
        None
    }
}

impl FromStr for Chart {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let graph = s
            .lines()
            .map(|line| {
                let comps: Vec<&str> = line.split(' ').take(5).collect();
                assert_eq!(comps[1], "to");
                assert_eq!(comps[3], "=");
                (comps[0], comps[2], f32::from_str(comps[4]).unwrap())
            })
            .fold(
                AdjacencyList::new(),
                |mut graph, (source, destination, weight)| {
                    graph.insert(source.to_string());
                    graph.add_directed_edge(
                        &Rc::new(source.to_string()),
                        &Rc::new(destination.to_string()),
                        Some(weight),
                    );
                    graph
                },
            );
        Ok(Self { graph })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    #[ignore]
    fn test_advent_puzzle() {
        let chart: Chart = util::Input::new("day09.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        let route = chart.shortest_route();
        assert_eq!(route.map(|r| r.cost), Some(0));
    }
}
