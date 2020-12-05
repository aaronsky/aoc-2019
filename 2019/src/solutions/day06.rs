use std::collections::{HashMap, HashSet};
use std::hash::Hash;
use std::str::FromStr;
use util::{AdjacencyList, Graph};

#[derive(Hash, Eq, PartialEq, Debug, Clone)]
pub enum OrbitalObject {
    You,
    Santa,
    Object(String),
}

impl From<&str> for OrbitalObject {
    fn from(string: &str) -> Self {
        match string {
            "YOU" => OrbitalObject::You,
            "SAN" => OrbitalObject::Santa,
            obj => OrbitalObject::Object(obj.to_string()),
        }
    }
}

#[derive(Debug)]
pub struct OrbitMap {
    all_objects: HashSet<OrbitalObject>,
    reverse_lookup: HashMap<OrbitalObject, OrbitalObject>,
}

impl OrbitMap {
    pub fn number_of_orbits(&self) -> usize {
        self.construct_orbital_path_map().len()
    }

    pub fn number_of_orbital_transfers_from_you_to_santa(&self) -> usize {
        let path_map = self.construct_orbital_path_map();
        assert!(path_map.contains_vertex(&OrbitalObject::You));
        assert!(path_map.contains_vertex(&OrbitalObject::Santa));
        let you_orbits: Vec<&OrbitalObject> = path_map
            .edges(&OrbitalObject::You)
            .iter()
            .map(|e| e.destination.as_ref())
            .collect();
        let santa_orbits: Vec<&OrbitalObject> = path_map
            .edges(&OrbitalObject::Santa)
            .iter()
            .map(|e| e.destination.as_ref())
            .collect();
        let mut last_matching_you_index = you_orbits.len() - 1;
        let mut last_matching_santa_index = santa_orbits.len() - 1;
        for (reverse_index, (you, santa)) in you_orbits
            .iter()
            .rev()
            .zip(santa_orbits.iter().rev())
            .enumerate()
        {
            if you != santa {
                break;
            }
            last_matching_you_index = you_orbits.len() - reverse_index - 1;
            last_matching_santa_index = santa_orbits.len() - reverse_index - 1;
        }
        let path: Vec<&&OrbitalObject> = you_orbits[..last_matching_you_index]
            .iter()
            .chain(santa_orbits[..=last_matching_santa_index].iter().rev())
            .collect();
        path.len() - 1
    }

    fn construct_orbital_path_map(&self) -> AdjacencyList<OrbitalObject> {
        let mut path_map: AdjacencyList<OrbitalObject> = Default::default();
        for obj in &self.all_objects {
            let mut current = obj;
            path_map.insert(obj.clone());
            while self.reverse_lookup.contains_key(current) {
                current = self.reverse_lookup.get(current).unwrap();
                path_map.add_directed_edge(
                    &std::rc::Rc::new(obj.clone()),
                    &std::rc::Rc::new(current.clone()),
                    None,
                );
            }
        }
        path_map
    }
}

impl FromStr for OrbitMap {
    type Err = ();

    fn from_str(input: &str) -> Result<Self, Self::Err> {
        let mut all_objects = HashSet::new();
        let mut reverse_lookup = HashMap::new();
        for line in input.split('\n') {
            let adjacency: Vec<&str> = line.split(')').take(2).map(str::trim).collect();
            if adjacency.len() != 2 {
                continue;
            }
            let (key, value) = (
                OrbitalObject::from(adjacency[1]),
                OrbitalObject::from(adjacency[0]),
            );
            all_objects.insert(key.clone());
            reverse_lookup.insert(key, value);
        }
        Ok(OrbitMap {
            all_objects,
            reverse_lookup,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn smoke_simple_program_1() {
        let input = "COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L";
        let orbit_map = OrbitMap::from_str(input).unwrap();
        assert_eq!(orbit_map.number_of_orbits(), 42);
    }

    #[test]
    fn smoke_simple_program_2() {
        let input = "COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        K)YOU
        I)SAN";
        let orbit_map = OrbitMap::from_str(input).unwrap();
        assert_eq!(orbit_map.number_of_orbital_transfers_from_you_to_santa(), 4);
    }

    #[test]
    fn test_advent_puzzle() {
        let orbit_map: OrbitMap = util::Input::new("day06.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        assert_eq!(
            orbit_map.number_of_orbital_transfers_from_you_to_santa(),
            496
        );
    }
}
