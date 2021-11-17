pub fn xmas_find_first_invalid_num(nums: &[u32], preamble_len: usize, sum_range_len: usize) -> u32 {
    let mut current_index = preamble_len;
    loop {
        if current_index >= nums.len() {
            break;
        }
        let target_num = nums[current_index];
        let mut found = false;
        'sum: for (i, a) in nums[current_index - sum_range_len..current_index]
            .iter()
            .enumerate()
        {
            for (j, b) in nums[current_index - sum_range_len..current_index]
                .iter()
                .enumerate()
            {
                if i == j {
                    continue;
                }
                if a + b == target_num {
                    found = true;
                    break 'sum;
                }
            }
        }
        if !found {
            return target_num;
        }
        current_index += 1;
    }

    0
}

// returns min and max values in contiguous set
pub fn xmas_find_contiguous_set_boundaries(nums: &[u32], target: u32) -> (u32, u32) {
    let mut min = 0;
    let mut max = 0;

    for i in 0..nums.len() {
        let mut total = 0;
        let mut j = i;

        while total < target {
            total += nums[j];
            j += 1;
        }

        if total == target {
            min = i;
            max = j;
            break;
        }
    }

    (
        nums[min..max]
            .iter()
            .min()
            .map(ToOwned::to_owned)
            .unwrap_or_default(),
        nums[min..max]
            .iter()
            .max()
            .map(ToOwned::to_owned)
            .unwrap_or_default(),
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input = util::Input::new("day09.txt", crate::YEAR)
            .unwrap()
            .into_vec::<u32>("\n");

        let first_invalid = xmas_find_first_invalid_num(&input, 25, 25);
        assert_eq!(first_invalid, 1212510616);

        let min_max = xmas_find_contiguous_set_boundaries(&input, first_invalid);
        assert_eq!(min_max.0 + min_max.1, 171265123);
    }
}
