use crate::math::Point2;
use std::convert::TryInto;

#[derive(Debug, PartialEq, Clone)]
pub struct Matrix<N> {
    pub elements: Vec<N>,
    pub width: usize,
    pub height: usize,
}

impl<N> Matrix<N> {
    pub fn get(&self, x: usize, y: usize) -> Option<&N> {
        self.elements.get(self.index(x, y))
    }

    pub fn get_mut(&mut self, x: usize, y: usize) -> Option<&mut N> {
        let index = self.index(x, y);
        self.elements.get_mut(index)
    }

    pub fn set(&mut self, x: usize, y: usize, value: N) {
        if let Some(x) = self.get_mut(x, y) {
            *x = value
        }
    }

    pub fn index(&self, x: usize, y: usize) -> usize {
        self.width * y + x
    }

    pub fn position(&self, index: usize) -> (usize, usize) {
        let x = index % self.width;
        let y = index / self.width;

        (x, y)
    }

    pub fn iter(&self) -> impl Iterator<Item = &N> {
        self.elements.iter()
    }

    pub fn positions(&self) -> impl Iterator<Item = (usize, usize)> + '_ {
        (0..self.elements.len()).map(move |i| self.position(i))
    }

    pub fn neighboring_positions(
        &self,
        x: usize,
        y: usize,
        diagonals: bool,
    ) -> impl Iterator<Item = (usize, usize)> {
        let mut neighbors = vec![];
        let (top, right, bottom, left) =
            (y == 0, x + 1 >= self.width, y + 1 >= self.height, x == 0);

        if !top {
            neighbors.push((x, y - 1));
        }
        if !right {
            neighbors.push((x + 1, y));
        }
        if !bottom {
            neighbors.push((x, y + 1));
        }
        if !left {
            neighbors.push((x - 1, y));
        }

        if diagonals {
            if !left && !top {
                neighbors.push((x - 1, y - 1));
            }
            if !left && !bottom {
                neighbors.push((x - 1, y + 1));
            }
            if !right && !top {
                neighbors.push((x + 1, y - 1));
            }
            if !right && !bottom {
                neighbors.push((x + 1, y + 1));
            }
        }

        neighbors.into_iter()
    }

    pub fn first<F>(&self, x: usize, y: usize, along: &Point2, matches: F) -> Option<&N>
    where
        F: Fn(&N) -> bool,
    {
        let mut p = Point2::new(x.try_into().ok()?, y.try_into().ok()?) + along;

        while let Some(el) = self.get(p.x.try_into().ok()?, p.y.try_into().ok()?) {
            if matches(el) {
                return Some(el);
            }
            p = p + along;
        }

        None
    }
}

impl<N> Default for Matrix<N> {
    fn default() -> Self {
        Self {
            elements: vec![],
            width: 0,
            height: 0,
        }
    }
}

impl<N> From<Vec<N>> for Matrix<N>
where
    N: Clone,
{
    fn from(elements: Vec<N>) -> Self {
        Self {
            elements,
            ..Default::default()
        }
    }
}

impl<N> IntoIterator for Matrix<N> {
    type Item = N;
    type IntoIter = std::vec::IntoIter<N>;

    fn into_iter(self) -> Self::IntoIter {
        self.elements.into_iter()
    }
}
