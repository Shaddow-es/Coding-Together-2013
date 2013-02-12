//
//  GameSettings.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 12/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "GameSettings.h"

@implementation GameSettings


// ---------------------------------------
//  -- Constants
// ---------------------------------------
#pragma mark - Constants

#define SETTINGS_KEY        @"GameSettings"
#define FLIP_ANIMATED_KEY   @"FlipAnimated"

// Syntetize necesario por implementar getter y setter
@synthesize flipAnimated = _flipAnimated;

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Obtiene una copia del diccionario con las opciones del UserDefaults
- (NSMutableDictionary *) getSettingsFromUserDefaults
{
    // Obtiene el diccionario de las puntuaciones del UserDefaults
    NSMutableDictionary *mutableSettingsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY] mutableCopy];
    if (!mutableSettingsFromUserDefaults) {
        mutableSettingsFromUserDefaults = [[NSMutableDictionary alloc] init];

        // Inicializa los valores por defecto
        mutableSettingsFromUserDefaults[FLIP_ANIMATED_KEY] = [NSNumber numberWithBool:YES];
    }
    return mutableSettingsFromUserDefaults;
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setFlipAnimated:(BOOL)flipAnimated
{
    _flipAnimated = flipAnimated;
    NSMutableDictionary *mutableSettingsFromUserDefaults = [self getSettingsFromUserDefaults];
    // Actualiza el valor de la propiedad en el diccionario
    mutableSettingsFromUserDefaults[FLIP_ANIMATED_KEY] = [NSNumber numberWithBool:_flipAnimated];
    // Guarda el diccionario modificado en el UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableSettingsFromUserDefaults forKey:SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) isFlipAnimated
{
    if (!_flipAnimated){
        NSMutableDictionary *mutableSettingsFromUserDefaults = [self getSettingsFromUserDefaults];
        _flipAnimated = [(NSNumber *) mutableSettingsFromUserDefaults[FLIP_ANIMATED_KEY] boolValue];
    }
    return _flipAnimated;
}

@end
