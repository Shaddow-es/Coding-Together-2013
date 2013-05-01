//
//  Deck.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation Deck

// Añade una carta a la baraja, indica si lo hace en la parte superior
- (void) addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card] ;
    }
}

// Saca una carta de la baraja
- (Card *) drawRandomCard
{
    Card *randomCard = nil;
    
    if (self.cards.count) {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (NSMutableArray *) cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init] ;
    return _cards;
}

- (NSUInteger) count
{
    return (self.cards) ? [self.cards count] : 0;
}
@end
