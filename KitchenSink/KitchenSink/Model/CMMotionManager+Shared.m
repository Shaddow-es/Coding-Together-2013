//
//  CMMotionManager+Shared.m
//  KitchenSink
//
//  Created by David Muñoz Fernández on 15/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CMMotionManager+Shared.h"

@implementation CMMotionManager (Shared)

+ (CMMotionManager *) sharedMotionManager
{
    static CMMotionManager *shared = nil;
    if (!nil) {
        // Si hay multiples threads intentando acceder a esto, evitamos condiciones de carrera
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[CMMotionManager alloc] init];
        });
    }
    return shared;
}
@end
