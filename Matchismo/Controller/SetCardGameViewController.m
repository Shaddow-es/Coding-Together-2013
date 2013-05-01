//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 10/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "GameSettings.h"
#import "CardMatchingGame.h"

@interface SetCardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *game;
@end

@implementation SetCardGameViewController

// ---------------------------------------
//  -- Constants
// ---------------------------------------
#define STARTING_CARD_COUNT 12
#define MATCH_COUNT 3

#define MATCH_BONUS 2
#define MISMATCH_PENALTY 4
#define FLIP_COST 2
#define NEW_CARD_COST 2

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
    return MATCH_COUNT;
}

// Bonus al marcador cuando se encuentra coincidencia
- (NSUInteger)matchBonus
{
    return MATCH_BONUS;
}

// Penalización al marcador cuando se falla una coincidencia
- (NSUInteger)mismatchPenalty
{
    return MISMATCH_PENALTY;
}

// Coste por el volteo de la carta
- (NSUInteger)flipCost
{
    return FLIP_COST;
}

// Coste por obtener una nueva carta de la baraja
- (NSUInteger)newCardCost
{
    return NEW_CARD_COST;
}

// Indica si se han de borrar las cartas que ya se encontro coincidencia
- (BOOL)removeCards
{
    return YES;
}

// ---------------------------------------
//  -- Abstract methods implementation
// ---------------------------------------
#pragma mark - Abstract methods implementation

// Crea una nueva baraja de cartas
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

// Actualiza una celda con el contenido de una carta
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *) card;
            
            // Animación de la carta si está siendo volteada
            if (animate && setCardView.selected!=setCard.faceUp){
                [UIView transitionWithView:setCardView
                                  duration:FLIP_ANIMATION_DURATION
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{}
                                completion:NULL];
            }
            
            setCardView.number = setCard.number;
            setCardView.symbol = setCard.symbol;
            setCardView.shade = setCard.shade;
            setCardView.color = setCard.color;
            setCardView.selected = setCard.faceUp;
            setCardView.alpha = (setCard.isUnplayable) ? 0.3 : 1.0;
        }
    }
}

// Devuelve un string con formato con el contenido de la carta
- (NSAttributedString *) cardAsAttributedString:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]){
        SetCard *setCard = (SetCard *) card;
        NSString *cardText = @"";
        for (int i=0; i < setCard.number; i++){
            cardText = [cardText stringByAppendingString:[self symbolToString:setCard.symbol]];
        }
        
        NSMutableAttributedString *cardAttributedString = [[NSMutableAttributedString alloc] initWithString:cardText];
        NSRange range = NSMakeRange(0, [cardText length]);
        UIColor *strokeColor = [self cardColor:setCard];
        UIColor *cardColor = (setCard.shade == SetCardShadeTypeStriped) ? [strokeColor colorWithAlphaComponent:0.4] : strokeColor;
        cardColor = (setCard.shade == SetCardShadeTypeOpen) ? [UIColor whiteColor] : cardColor;
        
        [cardAttributedString addAttribute:NSForegroundColorAttributeName
                                     value:cardColor
                                     range:range];
        [cardAttributedString addAttribute:NSStrokeColorAttributeName
                                     value:strokeColor
                                     range:range];
        [cardAttributedString addAttribute:NSStrokeWidthAttributeName
                                     value:@-7
                                     range:range];
        [cardAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" - "]];
        
        return [cardAttributedString attributedSubstringFromRange:range];
    }
    return [[NSAttributedString alloc] initWithString:card.contents];
}

// Devuelve el identificador de la celda (UICollectionViewCell)
- (NSString *)collectionViewCellIdentifier
{
    return @"SetCard";
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

- (UIColor *) cardColor:(SetCard *)card
{
    UIColor *color;
    if (card.color == SetCardColorTypeRed) {
        color = [UIColor redColor];
    } else if (card.color == SetCardColorTypeGreen) {
        color = [UIColor greenColor];
    } else if (card.color == SetCardColorTypePurple) {
        color = [UIColor purpleColor];
    }

    return color;
}

// Convierte un símbolo a un string
- (NSString *)symbolToString:(SetCardSymbolType)symbolType
{
    switch(symbolType){
        case SetCardSymbolTypeDiamond:
            return @"▲";
        case SetCardSymbolTypeSquiggle:
            return @"■";
        case SetCardSymbolTypeOval:
            return @"●";
    }
}

@end
