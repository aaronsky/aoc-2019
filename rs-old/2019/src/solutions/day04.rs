use std::u8::MAX as U8_MAX;

pub fn is_valid_password(candidate: u32, range_start: u32, range_end: u32) -> bool {
    let num_digits = util::number_of_digits(candidate as f64) as u32;
    assert!(num_digits == 6);
    assert!(candidate >= range_start && candidate <= range_end);

    let mut successful_candidate = true;
    let mut adjacent_sequence = String::new();
    let mut found_a_sequence_of_exactly_two_digits = false;
    let mut last_number = U8_MAX;

    for i in 0..=num_digits {
        let digit = util::digit_at_index(num_digits - i, candidate);
        if last_number == U8_MAX {
            adjacent_sequence.push(digit as char);
        } else if digit < last_number {
            successful_candidate = false;
            break;
        } else if digit == last_number {
            adjacent_sequence.push(digit as char);
        } else {
            found_a_sequence_of_exactly_two_digits |= adjacent_sequence.len() == 2;
            adjacent_sequence = String::new();
            adjacent_sequence.push(digit as char);
        }
        last_number = digit;
    }

    found_a_sequence_of_exactly_two_digits |= adjacent_sequence.len() == 2;

    if successful_candidate && found_a_sequence_of_exactly_two_digits {
        return true;
    }
    false
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    fn parse(input: &str) -> (u32, u32) {
        let range: Vec<u32> = input.split("-").take(2).map(str_to_u32).collect();
        (range[0], range[1])
    }

    fn str_to_u32(string: &str) -> u32 {
        string.parse::<u32>().unwrap()
    }

    #[test]
    fn test_advent_puzzle() {
        let range_str = util::Input::new("day04.txt", crate::YEAR)
            .unwrap()
            .to_string();
        let (start, end) = parse(&range_str);
        let possibilities_count = (start..end)
            .filter(|num| is_valid_password(*num, start, end))
            .count();
        assert_eq!(possibilities_count, 1196);
    }

    #[test]
    fn smoke_simple_program_1() {
        assert!(is_valid_password(112233, 112233, 112233));
    }

    #[test]
    fn smoke_simple_program_2() {
        assert!(!is_valid_password(123444, 123444, 123444));
    }

    #[test]
    fn smoke_simple_program_3() {
        assert!(is_valid_password(111122, 111122, 111122));
    }
}
