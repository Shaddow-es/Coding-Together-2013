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

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

// ---------------------------------------
//  -- Private methods (to implement in subclass)
// ---------------------------------------
#define MATCH_BONUS 2
#define MISMATCH_PENALTY 4
#define FLIP_COST 2

// ---------------------------------------
//  -- Private methods (to implement in subclass)
// ---------------------------------------
#pragma mark - Private Methods to oimplement in subclass


#define DEFAULT_MATCH_MODE 3
// Devuelve el número de cartas sobre las que se buscarán coincidencias
- (int) getMatchCount
{
    return DEFAULT_MATCH_MODE;
}

- (int) getMatchBonus
{
    return MATCH_BONUS;
}

// Cuanto mayor nº cartas, más penalización
- (int) getMisMatchPenalty
{
    return MISMATCH_PENALTY;
}

// Cuanto mayor nº cartas, más coste por voltear
- (int) getFlipCost
{
    return FLIP_COST;
}

- (Deck *) getDeck
{
    return [[SetCardDeck alloc] init];
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Devuelve un string con formato con el contenido de la carta
- (NSAttributedString *) cardAsAttributedString:(Card *)card
{
    if ([card isKindOfClass:[SetCard class]]){
        SetCard *setCard = (SetCard *) card;
        NSString *cardText = @"";
        for (int i=0; i < setCard.number; i++){
            cardText = [cardText stringByAppendingString:setCard.symbol];
        }
        
        NSMutableAttributedString *cardAttributedString = [[NSMutableAttributedString alloc] initWithString:cardText];
        NSRange range = NSMakeRange(0, [cardText length]);
        UIColor *strokeColor = [self cardColor:setCard];
        UIColor *cardColor = (setCard.shade == SetCardShadeTypeStriped) ? [strokeColor colorWithAlphaComponent:0.2] : strokeColor;
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

@end
