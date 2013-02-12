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
//         cardCount: Número de cartas a jugar
//              deck: baraja desde la que obtener cartas
//         matchMode: Número de cartas sobre las que buscar coincidencias
//        matchBonus: Bonus otorgado al obtener una coincidencia
//   missmatchPenaly: Penalización por fallo
//          flipCost: Coste por voltear una carta
- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck
               matchMode:(NSUInteger)matchCount
              matchBonus:(NSUInteger)matchBonus
         mismatchPenaly:(NSUInteger)missmatchPenalty
               flipCost:(NSUInteger)flipCost;

// Voltea la carta en el lugar indicado
- (void) flipCardAtIndex:(NSUInteger)index;

// Obtiene la carta del lugar indicado
- (Card *) cardAtIndex:(NSUInteger)index;

// Propiedades de solo lectura
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int matchMode;
@property (strong, nonatomic, readonly) NSMutableArray *moves; // of CardMove
@property (nonatomic, readonly, getter = isGameOver) BOOL gameOver;

@end
