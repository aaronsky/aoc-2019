use itertools::Itertools;
use std::ops::Mul;
use std::str::FromStr;
use std::{fmt::Display, ops::Add};

#[derive(Debug, PartialEq)]
pub enum Operator {
    Add,
    Mul,
}

impl Operator {
    fn operate(&self, left: &Expression, right: &Expression) -> f64 {
        let arithmetic_fn = match self {
            Operator::Add => Add::add,
            Operator::Mul => Mul::mul,
        };

        match (left, right) {
            (Expression::Scalar(l), Expression::Operation(l2, r, op2)) => {
                if let Expression::Scalar(l2_val) = **l2 {
                    op2.operate(&Expression::Scalar(arithmetic_fn(*l, l2_val)), r)
                } else {
                    arithmetic_fn(left.evaluate(), right.evaluate())
                }
            }
            _ => arithmetic_fn(left.evaluate(), right.evaluate()),
        }
    }
}

impl Display for Operator {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Operator::Add => write!(f, "+"),
            Operator::Mul => write!(f, "*"),
        }
    }
}

#[derive(Debug, PartialEq)]
pub enum Expression {
    Scalar(f64),
    Group(Box<Expression>),
    Operation(Box<Expression>, Box<Expression>, Operator),
}

impl Expression {
    pub fn evaluate(&self) -> f64 {
        let res = match self {
            Self::Scalar(v) => *v,
            Self::Group(group) => group.evaluate(),
            Self::Operation(left, right, op) => op.operate(left, right),
        };

        println!("{} = {}", self, res);

        res
    }
}

impl Display for Expression {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Expression::Scalar(n) => write!(f, "{}", n),
            Expression::Group(expr) => write!(f, "({})", expr),
            Expression::Operation(l, r, op) => write!(f, "{} {} {}", l, r, op),
        }
    }
}

impl FromStr for Expression {
    type Err = String;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let nodes = s.chars().filter(|c| !c.is_whitespace()).collect_vec();
        Self::parse_expression(&nodes, 0)
            .map(|(_, e)| e)
            .ok_or(s.to_string())
    }
}

impl Expression {
    fn parse_expression(nodes: &Vec<char>, position: usize) -> Option<(usize, Self)> {
        match Self::parse_start(nodes, position) {
            Some((new_position, left)) => match Self::parse_operator(nodes, new_position) {
                Some((new_position_2, op)) => match Self::parse_expression(nodes, new_position_2) {
                    Some((new_position_3, right)) => {
                        Some((new_position_3, Self::combine(left, right, op)))
                    }
                    None => None,
                },
                None => Some((new_position, left)),
            },
            None => None,
        }
    }

    fn combine(left: Self, right: Self, op: Operator) -> Self {
        match right {
            Self::Operation(left2, right2, op2) => Self::Operation(
                Box::new(left),
                Box::new(Self::Operation(left2, right2, op2)),
                op,
            ),
            _ => Self::Operation(Box::new(left), Box::new(right), op),
        }
    }

    fn parse_start(nodes: &Vec<char>, position: usize) -> Option<(usize, Self)> {
        match Self::parse_start_parenthesis(nodes, position) {
            Some(new_position) => {
                let r = Self::parse_expression(nodes, new_position);
                Self::parse_end_parenthesis(nodes, r)
            }
            None => Self::parse_scalar(nodes, position),
        }
    }

    fn parse_start_parenthesis(nodes: &Vec<char>, position: usize) -> Option<usize> {
        if position < nodes.len() && nodes[position] == '(' {
            Some(position + 1)
        } else {
            None
        }
    }

    fn parse_end_parenthesis(
        nodes: &Vec<char>,
        wrapped: Option<(usize, Self)>,
    ) -> Option<(usize, Self)> {
        match wrapped {
            Some((position, expr)) => {
                if position < nodes.len() && nodes[position] == ')' {
                    Some((position + 1, Self::Group(Box::new(expr))))
                } else {
                    None
                }
            }
            None => None,
        }
    }

    fn parse_scalar(nodes: &Vec<char>, position: usize) -> Option<(usize, Self)> {
        let mut new_position = position;
        if new_position < nodes.len() && nodes[new_position] == '-' {
            new_position = new_position + 1;
        }

        while new_position < nodes.len()
            && (nodes[new_position] == '.'
                || (nodes[new_position] >= '0' && nodes[new_position] <= '9'))
        {
            new_position = new_position + 1;
        }

        if new_position > position {
            if let Ok(v) = str::parse(&nodes[position..new_position].iter().collect::<String>()) {
                Some((new_position, Self::Scalar(v)))
            } else {
                None
            }
        } else {
            None
        }
    }

    fn parse_operator(nodes: &Vec<char>, position: usize) -> Option<(usize, Operator)> {
        if position < nodes.len() {
            let ops_with_char = vec![
                ('+', Operator::Add),
                ('*', Operator::Mul),
                // ('-', Operator::Substract),
                // ('/', Operator::Divide),
            ];
            for (ch, op) in ops_with_char {
                if nodes[position] == ch {
                    return Some((position + 1, op));
                }
            }
        }
        None
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let input = util::Input::new("day18.txt", crate::YEAR)
            .unwrap()
            .into_vec("\n");

        let sum: f64 = input.iter().map(Expression::evaluate).sum();

        assert_eq!(sum, 13632.0);
    }
}
