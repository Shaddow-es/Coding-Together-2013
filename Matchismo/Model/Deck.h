//
//  Deck.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

// Añade una carta a la baraja, indica si lo hace en la parte superior
- (void) addCard:(Card *)card atTop:(BOOL)atTop;
// Saca una carta de la baraja
- (Card *) drawRandomCard;

@end
