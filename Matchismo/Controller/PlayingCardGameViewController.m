//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 09/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "GameSettings.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

// ---------------------------------------
//  -- Constants
// ---------------------------------------
#define STARTING_CARD_COUNT 22

#define MATCH_BONUS 4
#define MISMATCH_COST_BASE 2
#define FLIP_COST_BASE 1

#define FLIP_ANIMATION_DURATION 0.30

// ---------------------------------------
//  -- Abstract properties implementation
// ---------------------------------------
#pragma mark - Abstract properties implementation

// Número de cartas con las que se inicia la partida
- (NSUInteger)startingCardCount
{
    return STARTING_CARD_COUNT;
}

// Número de cartas sobre las que buscar coincidencias
- (NSUInteger)matchCount
{
    return [GameSettings matchismoMatchCount];
}

// Bonus al marcador cuando se encuentra coincidencia
- (NSUInteger)matchBonus
{
    return MATCH_BONUS;
}

// Penalización al marcador cuando se falla una coincidencia
- (NSUInteger)mismatchPenalty
{
    return (MISMATCH_COST_BASE * (self.matchCount-1));
}

// Coste por el volteo de la carta
- (NSUInteger)flipCost
{
        return (FLIP_COST_BASE * (self.matchCount-1));
}

// Indica si se han de borrar las cartas que ya se encontro coincidencia
- (BOOL)removeCards
{
    return NO;
}

// ---------------------------------------
//  -- Abstract methods implementation
// ---------------------------------------
#pragma mark - Abstract methods implementation

// Crea una nueva baraja de cartas
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

// Actualiza una celda con el contenido de una carta
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *) cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *) card;
            
            // Animación de la carta si está siendo volteada
            if (animate && playingCardView.faceUp!=playingCard.faceUp){
                [UIView transitionWithView:playingCardView
                                  duration:FLIP_ANIMATION_DURATION
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{}
                                completion:NULL];
            }
            
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.faceUp;
            playingCardView.alpha = (playingCard.isUnplayable) ? 0.3 : 1.0;
        }
    }
}

// Devuelve un string con formato con el contenido de la carta
- (NSAttributedString *) cardAsAttributedString:(Card *)card
{
    NSString *str = [NSString stringWithFormat:@"%@", card.contents];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range = NSMakeRange(0, [str length]);
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:range];
    
    return attributedString;
}

// Devuelve el identificador de la celda (UICollectionViewCell)
- (NSString *)collectionViewCellIdentifier
{
    return @"PlayingCard";
}

@end
