//
//  PlayingCard.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

// Necesario por implementar el getter y setter
@synthesize suit = _suit;

// ---------------------------------------
//  -- Class methods
// ---------------------------------------
#pragma mark - Class methods

// Array NSString con los palos válidos
+ (NSArray *) validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) {
        validSuits = @[@"♠", @"♣", @"♥", @"♦"];
    }
    return validSuits;
}

// Número máximo de cartas para un palo
+ (NSArray *) rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) {
        rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    }
    return rankStrings;
}

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

- (int) match:(NSArray *)otherCards
{
    NSMutableArray *cards = [NSMutableArray arrayWithArray:otherCards];
    [cards addObject:self];
    int score = [self scoreMatch:cards];

    // Divide la puntuación según el número de cartas
    score = ceil((float)score / (float)otherCards.count);
    return score;
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Devuelve la puntuación de la comprobación de todas las cartas con todas
- (int) scoreMatch:(NSMutableArray *)cards
{
    int score = 0;
    if ([cards lastObject]){
        // Obtiene la última carta del array y la saca de la lista
        PlayingCard *lastCard = [cards lastObject];
        [cards removeLastObject];
        
        // Calcula la puntuación de la carta extraida con el resto de cartas
        for (PlayingCard *otherCard in cards) {
            score += [self scoreMatch:lastCard otherCard:otherCard];
        }
        
        // Llama de forma recursiva al resto del array de cartas
        score += [self scoreMatch:cards];
    }
    return score;
}

#define SCORE_MATCH_RANK 8
#define SCORE_MATCH_SUIT 2
// Calcula la puntuación entre 2 cartas
- (int) scoreMatch:(PlayingCard *)card otherCard:(PlayingCard *)otherCard
{
    int score = 0;
    
    if (otherCard.rank == card.rank) {
        score = SCORE_MATCH_RANK;
    } else if ([otherCard.suit isEqualToString:card.suit]) {
        score = SCORE_MATCH_SUIT;
    }
    
    NSLog(@"ScoreMatch %@-%@ = %d", card, otherCard, score);
    return score;
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

+ (NSUInteger) maxRank
{
    return [self rankStrings].count - 1;
}


- (NSString *) contents
{
    NSArray *rankStrings = [[self class] rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void) setSuit:(NSString *)suit
{
    if ([[[self class] validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
