//
//  PlayingCard.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

// Array NSString con los palos válidos
+ (NSArray *) validSuits;

// Número máximo de cartas
+ (NSUInteger) maxRank;

@end
