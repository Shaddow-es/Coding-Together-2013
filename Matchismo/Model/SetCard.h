//
//  SetCard.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 10/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Card.h"
#import "SetCardHelper.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbolType symbol;
@property (nonatomic) SetCardShadeType shade;
@property (nonatomic) SetCardColorType color;


// Array NSNumber con los números válidos
+ (NSArray *) validNumers;
// Array NSString con los símbolos válidos
+ (NSArray *) validSymbols;
// Array NSString con los rellenos válidos
+ (NSArray *) validShades;
// Array NSString con los colores válidos
+ (NSArray *) validColors;

@end
