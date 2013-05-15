//
//  CMMotionManager+Shared.h
//  KitchenSink
//
//  Created by David Muñoz Fernández on 15/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//s

#import <CoreMotion/CoreMotion.h>

@interface CMMotionManager (Shared)

+ (CMMotionManager *) sharedMotionManager;

@end
