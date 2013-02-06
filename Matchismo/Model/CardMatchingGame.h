//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 02/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Inicializador designado
//    cardCount: Número de cartas a jugar
//         deck: baraja desde la que obtener cartas
//   matchCount: Número de cartas sobre las que buscar coincidencias
- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck
          usingMatchMode:(NSUInteger)matchCount;

// Voltea la carta en el lugar indicado
- (void) flipCardAtIndex:(NSUInteger)index;

// Obtiene la carta del lugar indicado
- (Card *) cardAtIndex:(NSUInteger)index;

// Propiedades de solo lectura
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int matchMode;
@property (strong, nonatomic, readonly) NSMutableArray *history; // of NSString
@property (nonatomic, readonly, getter = isGameOver) BOOL gameOver;

@end
