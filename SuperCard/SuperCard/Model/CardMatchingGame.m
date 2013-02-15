//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 02/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardMatchingGame.h"
#import "GameResult.h"
#import "CardMove.h"

@interface CardMatchingGame ()
// Propiedades privadas
@property (strong, nonatomic) NSMutableArray *cards; // of Card
// La puntuación la almacenamos en la propiedad gameResult
@property (nonatomic, readwrite) GameResult *gameResult;
@property (strong, nonatomic, readwrite) NSMutableArray *moves; // of CardMove
@property (nonatomic, readwrite) int matchMode;
@property (nonatomic, readwrite, getter = isGameOver) BOOL gameOver;

// Propiedades para los costes
@property (nonatomic, readonly) NSUInteger matchBonus;
@property (nonatomic, readonly) NSUInteger flipCost;
@property (nonatomic, readonly) NSUInteger mismatchPenalty;
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
                flipCost:(NSUInteger)flipCost {
    self = [super init];
    
    if (self){
        for (int i = 0; i < cardCount; i++) {
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
        
        _matchMode = matchCount;
        _gameOver = NO;
        _gameResult = nil;
        _matchBonus = matchBonus;
        _mismatchPenalty = missmatchPenalty;
        _flipCost = flipCost;
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

// Obtiene la carta del lugar indicado
- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable){
        if (!card.isFaceUp){
            self.score -= self.flipCost;
            CardMove *cardMove = [[CardMove alloc] initWithActionType:CardMoveTypeFlipUp score:self.flipCost cards:@[card]];
            
            // Obtiene las cartas jugables y volteadas
            NSArray *cardsPlayabeAndFaceUp = [self cardsPlayabledAndFaceUp];
            // Si estan el juego en nº de cartas necesario para buscar coincidencias
            if (cardsPlayabeAndFaceUp.count == self.matchMode - 1){
                int matchScore = [card match:cardsPlayabeAndFaceUp];
                                
                if (matchScore) {
                    // Hay coincidencia
                    [self markCards:[cardsPlayabeAndFaceUp arrayByAddingObject:card] unplayable:YES faceUp:YES];
                    self.score += matchScore * self.matchBonus;
                    cardMove = [[CardMove alloc] initWithActionType:CardMoveTypeMatch
                                                              score:(matchScore * self.matchBonus)
                                                              cards:[cardsPlayabeAndFaceUp arrayByAddingObject:card]];
                } else {
                    // Fallo, no hay coincidencia
                    // Da la vuelta al resto de cartas y decrementa la puntuación
                    [self markCards:cardsPlayabeAndFaceUp unplayable:NO faceUp:NO];
                    // Cuantas más cartas se comprueben mayor es la penalización
                    self.score -= self.mismatchPenalty;
                    cardMove = [[CardMove alloc] initWithActionType:CardMoveTypeMismatch
                                                              score:(self.mismatchPenalty)
                                                              cards:[cardsPlayabeAndFaceUp arrayByAddingObject:card]];
                }
            }
            [self.moves addObject:cardMove];
            // Comprueba si el juego está acabado (así
            if ( [self checkGameIsOver] ) {
                self.gameOver = YES;
                [self.moves addObject:[[CardMove alloc] initWithGameFinished] ];
                // Almacena la puntuación en el UserDefaults
                [self.gameResult saveScoresInUserDefaults];
            }
            // La carta no estaba volteada
            card.faceUp = NO;
        }
        card.faceUp = !card.faceUp; // da la vuelta a la carta
    }
}


// Comprueba si el juego ha terminado
- (BOOL) checkGameIsOver
{
    // Obtiene todas las cartas en juego
    NSMutableArray *cardsNotFaceUp = [[NSMutableArray alloc] init];
    for (Card *card in self.cards) {
        if (!card.isUnplayable){
            [cardsNotFaceUp addObject:card];
        }
    }
    
    // Si hay menos cartas en juego que las requeridas -> Fin del juego
    if (cardsNotFaceUp && (cardsNotFaceUp.count < self.matchMode)) {
        // Pone visibles todas las cartas no jugables
        [self markCards:cardsNotFaceUp unplayable:NO faceUp:YES];
        return YES;
    }
    
    // Para todas las cartas en juego comprueba si hay coincidencia    
    for (Card *card in cardsNotFaceUp) {
        NSMutableArray *othersCards = [NSMutableArray arrayWithArray:cardsNotFaceUp];
        [othersCards removeObject:card];
        if ([card match:othersCards]){
            return NO;
        }
    }
    
    // Pone visibles todas las cartas no jugables
    [self markCards:cardsNotFaceUp unplayable:NO faceUp:YES];
    return YES;
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

- (NSMutableArray *) moves{
    if (!_moves){
        CardMove *cardMove = [[CardMove alloc] initWithGameStarted];
        _moves = [NSMutableArray arrayWithArray:@[cardMove]];
    }
    return _moves;
}

- (int) matchMode {
    // Valor por defecto 2
    return (!_matchMode) ? 2 : _matchMode;
}

- (GameResult *) gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
    }
    return _gameResult;
}

- (int) score
{
    return self.gameResult.score;
}

- (void) setScore:(int)score
{
    self.gameResult.score = score;
}
@end
