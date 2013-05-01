//
//  SetCardView.h
//  SuperSetCard
//
//  Created by David Muñoz Fernández on 17/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardHelper.h"

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetCardSymbolType symbol;
@property (nonatomic) SetCardShadeType shade;
@property (nonatomic) SetCardColorType color;
@property (nonatomic, getter = isSelected) BOOL selected;

@end
