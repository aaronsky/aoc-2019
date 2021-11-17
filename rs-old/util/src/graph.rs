use std::rc::Rc;

mod adjacency_list;
mod dijkstra;

pub use adjacency_list::*;
pub use dijkstra::*;

pub trait Graph {
    type Element;

    fn edges(&self, source: &Self::Element) -> &Vec<Edge<Self::Element>>;

    fn weight(&self, source: &Self::Element, destination: &Self::Element) -> Option<f32>;

    fn insert(&mut self, data: Self::Element);

    fn add_directed_edge(
        &mut self,
        source: &Rc<Self::Element>,
        destination: &Rc<Self::Element>,
        weight: Option<f32>,
    );

    fn add_undirected_edge(
        &mut self,
        source: &Rc<Self::Element>,
        destination: &Rc<Self::Element>,
        weight: Option<f32>,
    ) {
        self.add_directed_edge(source, destination, weight);
        self.add_directed_edge(destination, source, weight);
    }

    fn add_edge(
        &mut self,
        edge: EdgeType,
        source: &Rc<Self::Element>,
        destination: &Rc<Self::Element>,
        weight: Option<f32>,
    ) {
        match edge {
            EdgeType::Directed => self.add_directed_edge(source, destination, weight),
            EdgeType::Undirected => self.add_undirected_edge(source, destination, weight),
        }
    }
}

#[derive(Debug)]
pub struct Edge<Element> {
    pub source: Rc<Element>,
    pub destination: Rc<Element>,
    pub weight: Option<f32>,
}

pub enum EdgeType {
    Directed,
    Undirected,
}
