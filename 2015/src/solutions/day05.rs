use std::collections::HashSet;

pub fn count_nice_strings<F>(strings: &[String], is_nice: F) -> usize
where
    F: Fn(&str) -> bool,
{
    let mut count = 0;

    for s in strings {
        if is_nice(s) {
            count += 1;
        }
    }

    count
}

pub fn is_nice_one(s: &str) -> bool {
    let mut previous_char = char::default();

    /*
    A nice string is one with all of the following properties:
    */

    // It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
    let mut satisfies_rule_one = false;
    let mut count_vowels = 0;
    // It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
    let mut satisfies_rule_two = false;
    // It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
    let mut satisfies_rule_three = true;

    for (i, c) in s.chars().enumerate() {
        if c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' {
            count_vowels += 1;

            if count_vowels >= 3 {
                satisfies_rule_one = true;
            }
        }

        if i > 0 {
            assert_ne!(previous_char, char::default());

            if c == previous_char {
                satisfies_rule_two = true;
            }

            if previous_char == 'a' && c == 'b'
                || previous_char == 'c' && c == 'd'
                || previous_char == 'p' && c == 'q'
                || previous_char == 'x' && c == 'y'
            {
                satisfies_rule_three = false;
            }
        }

        previous_char = c;
    }

    satisfies_rule_one && satisfies_rule_two && satisfies_rule_three
}

pub fn is_nice_two(s: &str) -> bool {
    let mut prev_char: char = char::default();
    /*
    A nice string is one with all of the following properties:
    */

    // It contains a pair of any two letters that appears at least twice in the string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like aaa (aa, but it overlaps).
    let mut satisfies_rule_one = false;
    let mut letter_pairs = HashSet::new();
    let mut consecutive_chars_count = 1;
    // It contains at least one letter which repeats with exactly one letter between them, like xyx, abcdefeghi (efe), or even aaa.
    let mut satisfies_rule_two = false;
    let mut prev_prev_char = Default::default();

    for (i, c) in s.chars().enumerate() {
        if i > 0 {
            assert_ne!(prev_char, char::default());

            if prev_char == c {
                consecutive_chars_count += 1;
            } else {
                consecutive_chars_count = 1;
            }

            if consecutive_chars_count != 3 && !letter_pairs.insert((prev_char, c)) {
                satisfies_rule_one = true;
            }
        }

        if i > 1 {
            assert_ne!(prev_prev_char, char::default());

            if prev_prev_char == c {
                satisfies_rule_two = true;
            }
        }

        prev_prev_char = prev_char;
        prev_char = c;
    }

    satisfies_rule_one && satisfies_rule_two
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let strings = util::Input::new("day05.txt", crate::YEAR)
            .unwrap()
            .to_vec("\n");
        assert_eq!(count_nice_strings(&strings, is_nice_one), 255);
        assert_eq!(count_nice_strings(&strings, is_nice_two), 55);
    }
}
