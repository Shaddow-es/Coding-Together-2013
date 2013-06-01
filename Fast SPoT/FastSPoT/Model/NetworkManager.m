//
//  NetworkManager.m
//  SPoT
//
//  Created by David Muñoz Fernández on 21/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "NetworkManager.h"

// Número de conexiones abiertas
static NSInteger _connections;

@implementation NetworkManager


// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - public methods

+ (void) downloadStarted
{
    // Si la barra de estado está oculta no hace nada
    if ([[UIApplication sharedApplication] isStatusBarHidden]) return;
    
    @synchronized ([UIApplication sharedApplication]) {
        _connections++;
        [self updateNetwotkActiviyIndicator];
    }
}

+ (void) downloadFinished
{
    // Si la barra de estado está oculta no hace nada
    if ([[UIApplication sharedApplication] isStatusBarHidden]) return;
    
    @synchronized ([UIApplication sharedApplication]) {
        _connections--;
        [self updateNetwotkActiviyIndicator];
    }

}

// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - privated methods

+ (void) updateNetwotkActiviyIndicator
{
    if (_connections > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}
@end
