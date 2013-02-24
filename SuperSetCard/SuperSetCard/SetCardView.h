//
//  SetCardView.h
//  SuperSetCard
//
//  Created by David Muñoz Fernández on 17/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView


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

typedef NS_ENUM(NSInteger, SetCardSymbolType) {
    SetCardSymbolTypeDiamond,
    SetCardSymbolTypeSquiggle,
    SetCardSymbolTypeOval
};

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbolType symbol;
@property (nonatomic) SetCardShadeType shade;
@property (nonatomic) SetCardColorType color;

@end
