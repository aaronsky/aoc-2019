use itertools::Itertools;

pub fn fix_expense_report_doubles(input: &[u32]) -> u32 {
    let mut num1 = 0;
    let mut num2 = 0;

    for c in input.iter().combinations(2) {
        if c[0] + c[1] == 2020 {
            num1 = *c[0];
            num2 = *c[1];
        }
    }

    num1 * num2
}

pub fn fix_expense_report_triples(input: &[u32]) -> u32 {
    let mut num1 = 0;
    let mut num2 = 0;
    let mut num3 = 0;

    for c in input.iter().combinations(3) {
        if c[0] + c[1] + c[2] == 2020 {
            num1 = *c[0];
            num2 = *c[1];
            num3 = *c[2];
        }
    }

    num1 * num2 * num3
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input = util::Input::new("day01.txt", crate::YEAR)
            .unwrap()
            .into_vec("\n");
        assert_eq!(fix_expense_report_doubles(&input), 32064);
        assert_eq!(fix_expense_report_triples(&input), 193598720);
    }
}
