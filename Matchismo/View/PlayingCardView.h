//
//  PlayingCardView.h
//  SuperCard
//
//  Created by David Muñoz Fernández on 15/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
