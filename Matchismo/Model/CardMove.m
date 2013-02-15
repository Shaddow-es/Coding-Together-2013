//
//  CardAction.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 11/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardMove.h"

@implementation CardMove

// ---------------------------------------
//  -- Constructors
// ---------------------------------------
#pragma mark - Constructors

// Inicializador designado
- (id) initWithActionType:(CardMoveType)cardMoveType score:(NSUInteger)score cards:(NSArray *)cards
{
    self = [super init];
    
    if (self){
        _type = cardMoveType;
        _score = score;
        _cards = cards;
    }
    
    return self;
}

- (id) initWithGameFinished
{
    return [self initWithActionType:CardMoveTypeGameFinished score:0 cards:@[]];
}

- (id) initWithGameStarted
{
    return [self initWithActionType:CardMoveTypeGameStarted score:0 cards:@[]];
}

// Forzamos el error
- (id) init
{
    return nil;
}

@end
