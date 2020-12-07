use super::*;
use std::collections::HashMap;
use std::fmt;
use std::hash;

pub struct AdjacencyList<T>(HashMap<T, Vec<Edge<T>>>);

impl<T> AdjacencyList<T> {
    pub fn new() -> Self {
        AdjacencyList(Default::default())
    }

    pub fn iter(&self) -> impl Iterator<Item = (&T, &Vec<Edge<T>>)> {
        self.0.iter()
    }

    pub fn len(&self) -> usize {
        self.0.iter().map(|(_, v)| v.len()).sum()
    }

    pub fn is_empty(&self) -> bool {
        self.0.is_empty()
    }
}

impl<T> AdjacencyList<T>
where
    T: hash::Hash + Eq,
{
    pub fn contains_vertex(&self, data: &T) -> bool {
        self.0.contains_key(data)
    }
}

impl<T> Graph for AdjacencyList<T>
where
    T: hash::Hash + Eq,
{
    type Element = T;

    fn edges(&self, source: &Self::Element) -> &Vec<Edge<Self::Element>> {
        self.0.get(source).unwrap()
    }

    fn weight(&self, source: &Self::Element, destination: &Self::Element) -> Option<f32> {
        self.edges(source)
            .iter()
            .find(|e| e.destination.as_ref() == destination)
            .and_then(|e| e.weight)
    }

    fn insert(&mut self, data: Self::Element) {
        if self.contains_vertex(&data) {
            return;
        }

        self.0.insert(data, vec![]);
    }

    fn add_directed_edge(
        &mut self,
        source: &Rc<Self::Element>,
        destination: &Rc<Self::Element>,
        weight: Option<f32>,
    ) {
        if !self.contains_vertex(source) {
            return;
        }

        let edge = Edge {
            source: Rc::clone(source),
            destination: Rc::clone(destination),
            weight,
        };

        match self.0.get_mut(&source) {
            Some(val) => val.push(edge),
            _ => {}
        };
    }
}

impl<T> fmt::Debug for AdjacencyList<T>
where
    T: fmt::Debug,
{
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?}", self.0)
    }
}

impl<T> Default for AdjacencyList<T> {
    fn default() -> Self {
        Self::new()
    }
}
