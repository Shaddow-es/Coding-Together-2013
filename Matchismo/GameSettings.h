//
//  GameSettings.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 12/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameSettings : NSObject

+ (void)setFlipAnimated:(BOOL)flipAnimated;
+ (BOOL)isFlipAnimated;

+ (void)setMatchismoMatchCount:(NSUInteger)matchismoMatchCount;
+ (NSUInteger)matchismoMatchCount;

@end
