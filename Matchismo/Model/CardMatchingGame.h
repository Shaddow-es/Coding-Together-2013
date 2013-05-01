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
//       newCardCost: Coste por obtener una nueva carta de la baraja (si hay coincidencias posibles)
//        removeCard: Indica si las cartas deben ser borradas o no
- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck
               matchMode:(NSUInteger)matchCount
              matchBonus:(NSUInteger)matchBonus
          mismatchPenaly:(NSUInteger)missmatchPenalty
                flipCost:(NSUInteger)flipCost
             newCardCost:(NSUInteger)newCardCost
             removeCards:(BOOL)removeCards;


// Voltea la carta en el lugar indicado
- (void) flipCardAtIndex:(NSUInteger)index;

// Obtiene la carta del lugar indicado
- (Card *) cardAtIndex:(NSUInteger)index;

// Pone más cartas en juego
// Devuelve YES cuando había cartas suficientes, NO cuando no las había
- (BOOL) playMoreCards:(NSUInteger)cardCount;

// Devuelve el número de cartas en juego
- (NSUInteger) numberOfCardsInPlay;

// Devuelve un array (of NSIndexPath) con las posiciones de las cartas introducidas 
- (NSArray *) indexesOfCards:(NSArray *)cards; //of Card

// Elimina las cartas del juego
- (void) removeCards:(NSArray *)cards; //of Card

// Propiedades de solo lectura
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int matchMode;
@property (strong, nonatomic, readonly) NSMutableArray *moves; // of CardMove
@property (nonatomic, readonly, getter = isGameOver) BOOL gameOver;

@end
