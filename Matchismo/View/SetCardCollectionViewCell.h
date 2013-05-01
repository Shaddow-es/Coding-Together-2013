//
//  SetCardCollectionViewCell.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 24/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCardView.h"

@interface SetCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@end
