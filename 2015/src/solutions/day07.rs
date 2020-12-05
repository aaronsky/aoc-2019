use std::collections::HashMap;
use std::str::FromStr;

#[derive(Debug, Clone)]
pub struct Instruction {
    expression: String,
    output: String,
    executed: bool,
}

impl FromStr for Instruction {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let components: Vec<&str> = s.split(" -> ").collect();
        let (expression, output) = (components[0].to_string(), components[1].to_string());

        Ok(Instruction {
            expression,
            output,
            executed: false,
        })
    }
}

#[derive(Debug)]
pub struct Circuit {
    wires: HashMap<String, u16>,
}

impl Circuit {
    pub fn new() -> Self {
        Circuit {
            wires: HashMap::new(),
        }
    }

    pub fn evaluate_instructions(&mut self, instructions: &[Instruction]) {
        let mut instructions_mut = instructions.to_vec();
        loop {
            let mut evaluated_this_loop = false;
            for instruction in instructions_mut.iter_mut() {
                if instruction.executed {
                    continue;
                }
                evaluated_this_loop = true;
                if let Some(value) = self.parse_expression(&instruction.expression) {
                    self.wires.insert(instruction.output.clone(), value);
                    instruction.executed = true;
                }
            }
            if !evaluated_this_loop {
                break;
            }
        }
    }

    fn parse_expression(&self, expression: &str) -> Option<u16> {
        let input: Vec<&str> = expression.trim().split(" ").collect();

        if input.len() == 1 {
            return self.get_value(input[0]);
        } else if input.len() == 2 && input[0] == "NOT" {
            return self.get_value(input[1]).map(|n| !n);
        }

        let (lhs, op, rhs) = (input[0], input[1], input[2]);
        let (lhs_val, rhs_val) = (self.get_value(lhs)?, self.get_value(rhs)?);

        match op {
            "AND" => Some(lhs_val & rhs_val),
            "OR" => Some(lhs_val | rhs_val),
            "LSHIFT" => Some(lhs_val << rhs_val),
            "RSHIFT" => Some(lhs_val >> rhs_val),
            _ => None,
        }
    }

    fn get_value(&self, v: &str) -> Option<u16> {
        u16::from_str(v)
            .ok()
            .or_else(|| self.wires.get(v).map(|n| *n))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let instructions = util::load_input_file("day07.txt", crate::YEAR)
            .unwrap()
            .into_vec::<Instruction>("\n");
        let mut circuit = Circuit::new();

        circuit.evaluate_instructions(&instructions);

        assert_eq!(circuit.get_value("a"), Some(956));
    }

    #[test]
    fn test_advent_puzzle_two() {
        let mut instructions = util::load_input_file("day07.txt", crate::YEAR)
            .unwrap()
            .into_vec::<Instruction>("\n");
        instructions[89] = Instruction::from_str("956 -> b").unwrap();
        let mut circuit = Circuit::new();

        circuit.evaluate_instructions(&instructions);

        assert_eq!(circuit.get_value("a"), Some(40149));
    }
}
