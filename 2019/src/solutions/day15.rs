use crate::shared::Direction;
use std::i64;

fn direction_to_i64(dir: Direction) -> i64 {
    match dir {
        Direction::Up => 1,
        Direction::Down => 2,
        Direction::Left => 3,
        Direction::Right => 4,
    }
}

fn i64_to_direction(num: i64) -> Direction {
    match num {
        1 => Direction::Up,
        2 => Direction::Down,
        3 => Direction::Left,
        4 => Direction::Right,
        _ => panic!("invalid direction {}", num),
    }
}

pub fn add_to_direction(dir: Direction, rhs: i64) -> Direction {
    let lhs: i64 = direction_to_i64(dir);
    let bit = lhs + rhs;
    match bit {
        1..=4 => i64_to_direction(bit),
        5..=i64::MAX => Direction::Up,
        i64::MIN..=0 => Direction::Up,
    }
}

#[derive(Debug, Clone, PartialEq)]
enum StatusCode {
    HitWall,
    Moved,
    MovedToTarget,
}

impl From<i64> for StatusCode {
    fn from(num: i64) -> Self {
        match num {
            0 => StatusCode::HitWall,
            1 => StatusCode::Moved,
            2 => StatusCode::MovedToTarget,
            _ => panic!("invalid status code {}", num),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::shared::{Intcode, Interrupt};
    use util;

    /*
    The remote control program executes the following steps in a loop forever:

        Accept a movement command via an input instruction.
        Send the movement command to the repair droid.
        Wait for the repair droid to finish the movement operation.
        Report on the status of the repair droid via an output instruction.

    Only four movement commands are understood: north (1), south (2), west (3), and east (4). Any other command is invalid.
    The movements differ in direction, but not in distance: in a long enough east-west hallway, a series of commands like
    4,4,4,4,3,3,3,3 would leave the repair droid back where it started.

    The repair droid can reply with any of the following status codes:

        0: The repair droid hit a wall. Its position has not changed.
        1: The repair droid has moved one step in the requested direction.
        2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.

    You don't know anything about the area around the repair droid, but you can figure it out by watching the status codes.
        */

    #[test]
    #[ignore]
    fn test_advent_puzzle_1() {
        let rom = util::Input::new("day15.txt", crate::YEAR)
            .unwrap()
            .into_vec(",");

        let mut program = Intcode::new(&rom);
        let mut last_status_code: Option<StatusCode> = None;
        let mut step_stack: Vec<Direction> = vec![];

        loop {
            match program.run() {
                Interrupt::WaitingForInput => match last_status_code {
                    Some(StatusCode::HitWall) => {
                        let last_step = step_stack.pop().unwrap_or(Direction::Up).clone();
                        let next_step = add_to_direction(last_step, 1);
                        step_stack.push(next_step);
                        println!("moving {:?} from a wall", next_step);
                        program.set_input(next_step as i64);
                    }
                    Some(StatusCode::Moved) => {
                        let next_step = step_stack.last().unwrap_or(&Direction::Up).clone();
                        step_stack.push(next_step);
                        println!("moving {:?}", next_step);
                        program.set_input(next_step as i64);
                    }
                    Some(StatusCode::MovedToTarget) => {
                        println!("moved to target!");
                        break;
                    }
                    None => {
                        let next_step = Direction::Up;
                        step_stack.push(next_step);
                        println!("initially moving {:?}", next_step);
                        program.set_input(next_step as i64);
                    }
                },
                Interrupt::Output(o) => {
                    let status = From::from(o);
                    println!("received status {:?}", status);
                    last_status_code = Some(status)
                }
                Interrupt::Halted => {
                    println!("halting");
                    break;
                }
            };
        }

        // assert_eq!(last_status_code, Some(StatusCode::MovedToTarget));
        println!("{}", step_stack.len());
    }
}
