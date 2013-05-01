//
//  SetCardDeck.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 10/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

// Inicializa la baraja de cartas con todas las combinaciones de cartas posible
- (id) init
{
    self = [super init];
    
    if (self) {
        
        for (NSNumber *number in [SetCard validNumers]) {
            for (NSNumber *symbol in [SetCard validSymbols]) {
                for (NSNumber *shade in [SetCard validShades]) {
                    for (NSNumber *color in [SetCard validColors]) {
                        SetCard *card = [[SetCard alloc] init];
                        
                        card.number = [number intValue];
                        card.symbol = [symbol intValue];
                        card.shade  = [shade intValue];
                        card.color  = [color intValue];
                        
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
