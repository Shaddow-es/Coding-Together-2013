//
//  CardAction.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 11/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardMove : NSObject

typedef NS_ENUM(NSInteger, CardMoveType) {
    CardMoveTypeFlipUp,
    CardMoveTypeMatch,
    CardMoveTypeMismatch,
    CardMoveTypeGameStarted,
    CardMoveTypeGameFinished
};

// Inicializador designado
- (id) initWithActionType:(CardMoveType) cardMoveType
                    score:(NSUInteger)score
                    cards:(NSArray *)cards;

- (id) initWithGameFinished;
- (id) initWithGameStarted;

// Propiedades de solo lectura
@property (nonatomic, readonly) CardMoveType type;
@property (nonatomic, readonly) NSUInteger score;
@property (nonatomic, readonly) NSArray *cards;

@end
