//
//  Card.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

// Comprueba puntuación para las coincidencias de la carta con el array de cartas 'otherCards'
// Devuelve 1 cuando la carta es igual a alguna de las otras cartas
- (int) match:(NSArray *)otherCards;

@end
