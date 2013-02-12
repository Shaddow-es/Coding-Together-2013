//
//  CardGameViewController.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 01/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController <UIAlertViewDelegate>

// Inicia una nueva partida
- (void) startNewGame;

@end
