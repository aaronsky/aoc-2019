use std::collections::VecDeque;
use std::iter::FromIterator;

#[derive(Debug, PartialEq)]
pub struct Player {
    cards: VecDeque<u32>,
}

impl Player {
    pub fn new(cards: &[u32]) -> Self {
        Self {
            cards: VecDeque::from_iter(cards.iter().cloned()),
        }
    }

    pub fn can_play(&self) -> bool {
        !self.cards.is_empty()
    }

    pub fn score(&self) -> u32 {
        self.cards.iter().enumerate().fold(0, |mut acc, (i, card)| {
            acc += card * ((self.cards.len() - i) as u32);
            acc
        })
    }

    pub fn draw_card(&mut self) -> Option<u32> {
        self.cards.pop_front()
    }

    pub fn claim_cards(&mut self, cards: &[u32]) {
        self.cards.extend(cards.iter())
    }
}

pub struct CombatGame {
    player1: Player,
    player2: Player,
}

impl CombatGame {
    pub fn new(p1_cards: &[u32], p2_cards: &[u32]) -> Self {
        Self {
            player1: Player::new(p1_cards),
            player2: Player::new(p2_cards),
        }
    }

    pub fn play_to_win(&mut self) -> &Player {
        while self.player1.can_play() && self.player2.can_play() {
            let card1 = self.player1.draw_card().unwrap();
            let card2 = self.player2.draw_card().unwrap();
            match card1.cmp(&card2) {
                // player 2
                std::cmp::Ordering::Less => self.player2.claim_cards(&[card2, card1]),
                // draw
                std::cmp::Ordering::Equal => {
                    self.player1.claim_cards(&[card1]);
                    self.player2.claim_cards(&[card2]);
                }
                // player 1
                std::cmp::Ordering::Greater => self.player1.claim_cards(&[card1, card2]),
            };
        }

        if self.player1.can_play() {
            &self.player1
        } else {
            &self.player2
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_advent_puzzle_one() {
        // let input = util::Input::new("day22.txt", crate::YEAR).unwrap();
        let mut game = CombatGame::new(
            &[
                31, 24, 5, 33, 7, 12, 30, 22, 48, 14, 16, 26, 18, 45, 4, 42, 25, 20, 46, 21, 40,
                38, 34, 17, 50,
            ],
            &[
                1, 3, 41, 8, 37, 35, 28, 39, 43, 29, 10, 27, 11, 36, 49, 32, 2, 23, 19, 9, 13, 15,
                47, 6, 44,
            ],
        );
        let winner = game.play_to_win();
        assert_eq!(winner.score(), 36257);
    }
}
