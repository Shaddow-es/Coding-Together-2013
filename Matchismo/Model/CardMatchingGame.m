//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 02/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
// Propiedades privadas
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@property (nonatomic, readwrite) int score;
@property (strong, nonatomic, readwrite) NSString *lastAction;
@property (nonatomic, readwrite) int matchMode;
@end

@implementation CardMatchingGame

// ---------------------------------------
//  -- Constructors
// ---------------------------------------
#pragma mark - Constructors

// El inicializador sin argumentos falla devolviendo un nil
- (id) init{
    return nil;
}

// Inicializador designado
//    cardCount: Número de cartas a jugar
//         deck: baraja desde la que obtener cartas
//   matchCount: Número de cartas sobre las que buscar coincidencias
- (id) initWithCardCount:(NSUInteger)count
               usingDeck:(Deck *)deck
          usingMatchMode:(NSUInteger)matchCount {
    self = [super init];
    
    if (self){
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            // Proteccion por si nos quedamos sin cartas en la baraja
            // Al añadir un nil a un array se produce un error
            if (card){
                self.cards[i] = card;
            }else{
                self = nil;
                break; // Inncecesario??? pq las llamadas a métodos sobre nil no casca
            }
        }
        
        self.matchMode = matchCount;
    }
    
    return self;
}

// ---------------------------------------
//  -- Instance methods
// ---------------------------------------
#pragma mark - Instance methods

// Voltea la carta en el lugar indicado
- (Card *) cardAtIndex:(NSUInteger)index {
    // Comprueba que no se sale de rango, en ese caso devuelve nil
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY (2 * (self.matchMode-1)) // Cuanto mayor nº cartas, más penalización
#define FLIP_COST (1 * (self.matchMode-1)) // Cuanto mayor nº cartas, más coste por voltear

// Obtiene la carta del lugar indicado
- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable){
        if (!card.isFaceUp){
            self.score -= FLIP_COST;
            self.lastAction = [NSString stringWithFormat:@"Voletada %@", card.contents];
            
            // Obtiene las cartas jugables y volteadas
            NSArray *cardsPlayabeAndFaceUp = [self cardsPlayabledAndFaceUp];
            // Si estan el juego en nº de cartas necesario para buscar coincidencias
            if (cardsPlayabeAndFaceUp.count == self.matchMode - 1){
                int matchScore = [card match:cardsPlayabeAndFaceUp];
                                
                if (matchScore) {
                    // Hay coincidencia
                    [self markCards:[cardsPlayabeAndFaceUp arrayByAddingObject:card] unplayable:YES faceUp:YES];
                    self.score += matchScore * MATCH_BONUS;
                    self.lastAction = [NSString stringWithFormat:@"Coincidencia %@ para %d puntos",
                                       [[cardsPlayabeAndFaceUp arrayByAddingObject:card] componentsJoinedByString:@","],
                                       matchScore * MATCH_BONUS];
                    // FIX: luego vuelve a dar la vuelta a la carta
                    card.faceUp = NO;
                } else {
                    // Fallo, no hay coincidencia
                    // Da la vuelta al resto de cartas y decrementa la puntuación
                    [self markCards:cardsPlayabeAndFaceUp unplayable:NO faceUp:NO];
                    // Cuantas más cartas se comprueben mayor es la penalización
                    self.score -= MISMATCH_PENALTY;
                    self.lastAction = [NSString stringWithFormat:@"%@ no coinciden! %d puntos penalización!",
                                       [[cardsPlayabeAndFaceUp arrayByAddingObject:card] componentsJoinedByString:@","],
                                       MISMATCH_PENALTY];
                }
            }
        }
        card.faceUp = !card.faceUp; // da la vuelta a la carta
    }
}


// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - Privated methods

// Devuelve un array con las cartas jugables y volteadas
- (NSArray *) cardsPlayabledAndFaceUp
{
    NSMutableArray *cardPlayableAndFaceUp = [[NSMutableArray alloc] init];

    for (Card *card in self.cards){
        if (card.isFaceUp && !card.isUnplayable) {
            [cardPlayableAndFaceUp addObject:card];
        }
    }
    
    return cardPlayableAndFaceUp;
}

// Marca las cartas como jugables S/N y volteadas S/N
- (void) markCards:(NSArray *)cards unplayable:(BOOL)unplayable faceUp:(BOOL)faceUp
{
    for(Card *otherCard in cards){
        [otherCard setUnplayable:unplayable];
        [otherCard setFaceUp:faceUp];
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (NSMutableArray *) cards {
    _cards = (!_cards) ? [[NSMutableArray alloc] init] : _cards;
    return _cards;
}

- (NSString *) lastAction{
    return (!_lastAction) ? @"Empezar partida!" : _lastAction;
}

- (int) matchMode {
    // Valor por defecto 2
    return (!_matchMode) ? 2 : _matchMode;
}

@end
