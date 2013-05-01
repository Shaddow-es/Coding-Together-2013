//
//  SuperSetCardViewController.m
//  SuperSetCard
//
//  Created by David Muñoz Fernández on 17/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SuperSetCardViewController.h"
#import "SetCardView.h"

@interface SuperSetCardViewController ()

@property (weak, nonatomic) IBOutlet SetCardView *setCardView;

@end

@implementation SuperSetCardViewController

- (void)setSetCardView:(SetCardView *)setCardView
{
    _setCardView = setCardView;
    
    _setCardView.color = SetCardColorTypeRed;
    _setCardView.shade = SetCardShadeTypeStriped;
    _setCardView.symbol = SetCardSymbolTypeSquiggle;
    _setCardView.number = 3;
    _setCardView.selected = NO;
    
//    _setCardView.shade = SetCardShadeTypeStriped;
}

@end
