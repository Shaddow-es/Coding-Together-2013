//
//  Card.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Card.h"

@implementation Card

// Comprueba puntuación para las coincidencias de la carta con el array de cartas 'otherCards'
// Devuelve 1 cuando la carta es igual a alguna de las otras cartas
- (int) match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

- (NSString *) description
{
    return self.contents;
}

@end
