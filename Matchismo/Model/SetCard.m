//
//  SetCard.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 10/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

@synthesize symbol = _symbol;
@synthesize shade = _shade;
@synthesize color = _color;


// ---------------------------------------
//  -- Constants
// ---------------------------------------

#define SCORE_MATCH 1

// ---------------------------------------
//  -- Class methods
// ---------------------------------------
#pragma mark - Class methods


// Array NSUInteger con los números válidos
+ (NSArray *) validNumers
{
    static NSArray *validNumers = nil;
    if (!validNumers) {
        validNumers = @[@1,@2,@3];
    }
    return validNumers;
}


// Array NSString con los símbolos válidos
+ (NSArray *) validSymbols
{
    static NSArray *validSymbols = nil;
    if (!validSymbols) {
        validSymbols = @[@"▲", @"●", @"■"];
    }
    return validSymbols;
}

// Array NSString con los rellenos válidos
+ (NSArray *) validShades
{
    static NSArray *validShades = nil;
    if (!validShades) {
        validShades = @[@(SetCardShadeTypeSolid), @(SetCardShadeTypeStriped), @(SetCardShadeTypeOpen)];
    }
    return validShades;
}

// Array NSString con los colores válidos
+ (NSArray *) validColors
{
    static NSArray *validColors = nil;
    if (!validColors) {
        validColors = @[@(SetCardColorTypeRed), @(SetCardColorTypeGreen), @(SetCardColorTypePurple)];
    }
    return validColors;
}

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    // Calcula la puntuación de la carta extraida con el resto de cartas
    for (Card *otherCard in otherCards) {
        if ([otherCard isKindOfClass:[SetCard class]]) {
            NSMutableArray *anotherCards = [NSMutableArray arrayWithArray:otherCards];
            [anotherCards removeObject:otherCards];
            for (Card *anotherCard in anotherCards) {
                if ([anotherCard isKindOfClass:[SetCard class]]) {
                    score += [self match:self otherCard:(SetCard *)otherCard anotherCard:(SetCard *)anotherCard];
                }
            }
        }
    }
    
    return score;
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Devuelve la puntuación de coincidencias entre 3 cartas
- (int) match:(SetCard *)card1
    otherCard:(SetCard *)card2
  anotherCard:(SetCard *)card3
{
    int score = 0;
    // Puntos por tener todas las cartas iguales
    if ((card1.number == card2.number) && (card1.number == card3.number)) {
        score += SCORE_MATCH; // todas las cartas tienen el mismo numero
    }
    if (([card1.symbol isEqualToString:card2.symbol]) &&
        ([card1.symbol isEqualToString:card3.symbol])) {
        score += SCORE_MATCH; // todas las cartas tienen el mismo símbolo
    }
    if ((card1.shade == card2.shade) &&
        (card1.shade == card3.shade)) {
        score += SCORE_MATCH; // todas las cartas tienen el mismo relleno
    }
    if ((card1.color == card2.color) &&
        (card1.color == card3.color)) {
        score += SCORE_MATCH; // todas las cartas tienen el mismo color
    }
    
    // Puntos por tener todas las cartas distintas
    if ((card1.number != card2.number) &&
        (card1.number != card3.number) &&
        (card2.number != card3.number)) {
        score += SCORE_MATCH; // todas las cartas tienen distinto numero
    }
    if ((card1.symbol != card2.symbol) &&
        (card1.symbol != card3.symbol) &&
        (card2.symbol != card3.symbol)) {
        score += SCORE_MATCH; // todas las cartas tienen distinto símbolo
    }
    if ((card1.shade != card2.shade) &&
        (card1.shade != card3.shade) &&
        (card2.shade != card3.shade)) {
        score += SCORE_MATCH; // todas las cartas tienen distinto relleno
    }
    if ((card1.color != card2.color) &&
        (card1.color != card3.color) &&
        (card2.color != card3.color)) {
        score += SCORE_MATCH; // todas las cartas tienen distinto color
    }
    
    return score;
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setNumber:(NSUInteger)number
{
    if ([[[self class] validNumers] containsObject:@(number)]) {
        _number = number;
    }
}

- (void) setSymbol:(NSString *)symbol
{
    if ([[[self class] validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
}

- (void) setShade:(SetCardShadeType)shade
{
    if ([[[self class] validShades] containsObject:@(shade)]) {
        _shade = shade;
    }
}

- (void) setColor:(SetCardColorType)color
{
    if ([[[self class] validColors] containsObject:@(color)]) {
        _color = color;
    }
}

@end
