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
#define MATCH_COUNT_KEY     @"MatchismoMatchCount"

#define DEFAULT_ANIMATED        YES
#define DEFAULT_MATCH_COUNT     2

// ---------------------------------------
//  -- Public class methods
// ---------------------------------------
#pragma mark - Public class methods

+ (void) setFlipAnimated:(BOOL)flipAnimated
{
    [self updateSettingToUserDefaults:FLIP_ANIMATED_KEY value:[NSNumber numberWithBool:flipAnimated]];
}

+ (BOOL) isFlipAnimated
{
    NSMutableDictionary *mutableSettingsFromUserDefaults = [self getSettingsFromUserDefaults];
    return [(NSNumber *) mutableSettingsFromUserDefaults[FLIP_ANIMATED_KEY] boolValue];
}

+ (void) setMatchismoMatchCount:(NSUInteger)matchismoMatchCount
{
    [self updateSettingToUserDefaults:MATCH_COUNT_KEY value:[NSNumber numberWithInt:matchismoMatchCount]];
}

+ (NSUInteger)matchismoMatchCount
{
    NSMutableDictionary *mutableSettingsFromUserDefaults = [self getSettingsFromUserDefaults];
    return [(NSNumber *) mutableSettingsFromUserDefaults[MATCH_COUNT_KEY] integerValue];
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Obtiene una copia del diccionario con las opciones del UserDefaults
+ (NSMutableDictionary *) getSettingsFromUserDefaults
{
    // Obtiene el diccionario de las puntuaciones del UserDefaults
    NSMutableDictionary *mutableSettingsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:SETTINGS_KEY] mutableCopy];
    if (!mutableSettingsFromUserDefaults) {
        mutableSettingsFromUserDefaults = [[NSMutableDictionary alloc] init];

        // Inicializa los valores por defecto
        mutableSettingsFromUserDefaults[FLIP_ANIMATED_KEY] = [NSNumber numberWithBool:DEFAULT_ANIMATED];
        mutableSettingsFromUserDefaults[MATCH_COUNT_KEY] = [NSNumber numberWithInt:DEFAULT_MATCH_COUNT];
    }
    return mutableSettingsFromUserDefaults;
}

+ (void)updateSettingToUserDefaults:(NSString *)setting value:(id)value
{
    NSMutableDictionary *mutableSettingsFromUserDefaults = [self getSettingsFromUserDefaults];
    // Actualiza el valor de la propiedad en el diccionario
    mutableSettingsFromUserDefaults[setting] = value;
    // Guarda el diccionario modificado en el UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableSettingsFromUserDefaults forKey:SETTINGS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
