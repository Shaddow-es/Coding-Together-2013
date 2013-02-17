//
//  CardGameViewController.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>


// ---------------------------------------
//  -- Abstract methods
// ---------------------------------------

// Crea una nueva baraja de cartas
- (Deck *)createDeck;

// Actualiza una celda con el contenido de una carta
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate;


// ---------------------------------------
//  -- Abstract properties
// ---------------------------------------

// Número de cartas con las que se inicia la partida
@property (nonatomic, readonly) NSUInteger startingCardCount;
// Número de cartas sobre las que buscar coincidencias
@property (nonatomic, readonly) NSUInteger matchCount;
// Bonus al marcador cuando se encuentra coincidencia
@property (nonatomic, readonly) NSUInteger matchBonus;
// Penalización al marcador cuando se falla una coincidencia
@property (nonatomic, readonly) NSUInteger mismatchPenalty;
// Coste por el volteo de la carta
@property (nonatomic, readonly) NSUInteger flipCost;

@end
