//
//  CardDisplayViewController.m
//  CardViewer
//
//  Created by David Muñoz Fernández on 16/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardDisplayViewController.h"
#import "PlayingCardView.h"

@interface CardDisplayViewController ()
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end

@implementation CardDisplayViewController


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.playingCardView.rank = self.rank;
    self.playingCardView.suit = self.suit;
    self.playingCardView.faceUp = YES;
}

@end
