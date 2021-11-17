// use super::*;
use std::cmp;
use std::rc::Rc;
// use std::collections::BinaryHeap;

// #[derive(Eq, PartialEq)]
// struct Visit<'a, Element: PartialEq + Eq + PartialOrd + Ord> {
//     position: &'a Element,
//     cost: usize,
// }

// impl<'a, Element> cmp::PartialOrd for Visit<'a, Element> {
//     fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
//         todo!()
//     }
// }

// impl<'a, Element> cmp::Ord for Visit<'a, Element> {
//     fn cmp(&self, other: &Self) -> cmp::Ordering {
//         todo!()
//     }
// }

#[derive(Debug, PartialEq, Eq)]
pub struct Route<Element> {
    pub order: Vec<Rc<Element>>,
    pub cost: u32,
}

impl<Element> cmp::PartialOrd for Route<Element>
where
    Element: PartialEq,
{
    fn partial_cmp(&self, other: &Self) -> Option<cmp::Ordering> {
        self.cost.partial_cmp(&other.cost)
    }
}

impl<Element> cmp::Ord for Route<Element>
where
    Element: Eq,
{
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        self.cost.cmp(&other.cost)
    }
}

// pub fn shortest_path_from_start<G, E>(graph: G, start: E) -> Option<Route<E>>
// where
//     G: Graph<Element = E>,
//     E: Ord,
// {
//     let mut heap = BinaryHeap::new();
//     heap.push(Visit {
//         position: start,
//         cost: 0,
//     });

//     while let Some(Visit { cost, position }) = heap.pop() {}

//     None
// }

// pub fn shortest_path_to_destination<G, E>(graph: G, destination: E) -> Option<Route<E>>
// where
//     G: Graph<Element = E>,
//     E: Ord,
// {
//     None
// }
