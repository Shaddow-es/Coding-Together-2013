//
//  SetCard.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 10/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

typedef NS_ENUM(NSInteger, SetCardColorType) {
    SetCardColorTypeRed,
    SetCardColorTypeGreen,
    SetCardColorTypePurple
};

typedef NS_ENUM(NSInteger, SetCardShadeType) {
    SetCardShadeTypeSolid,
    SetCardShadeTypeStriped,
    SetCardShadeTypeOpen
};

@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *symbol;
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
