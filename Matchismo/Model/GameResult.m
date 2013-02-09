//
//  GameResult.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 09/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "GameResult.h"

@interface GameResult()
@property (readwrite, nonatomic) NSDate *start;
@property (readwrite, nonatomic) NSDate *end;
@end

@implementation GameResult


// ---------------------------------------
//  -- Constants
// ---------------------------------------
#pragma mark - Constants

#define ALL_RESULTS_KEY @"GameResult_All"

#define START_KEY       @"StartDate"
#define END_KEY         @"EndKey"
#define SCORE_KEY       @"ScoreKey"

// ---------------------------------------
//  -- Initiators
// ---------------------------------------
#pragma mark - Initiators

// inicializador designado
- (id) init
{
    self = [super init];
    if (self) {
        _start = [NSDate date];
        _end = _start;
    }
    return self;
}

// Inicializador desde PropertyList¡
- (id) initFromPropertyList:(id)plist
{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _start = resultDictionary[START_KEY];
            _end = resultDictionary[END_KEY];
            _score = [resultDictionary[SCORE_KEY] intValue];
            if (!_start || !_end) {
                self = nil;
            }
        }
    }
    return self;
}

// ---------------------------------------
//  -- Class methods
// ---------------------------------------
#pragma mark - Class methods

// Devuelve un array de GameResult con los resultados almacenados en standardUserDefaults
+ (NSArray *) allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResult *result = [[GameResult alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

// Actualiza la puntuación en el diccionario de resultados de UserDefaults
- (void) saveScoresInUserDefaults
{
    // Obtiene el diccionario de las puntuaciones del UserDefaults
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) {
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    }
    // Actualiza el valor de la puntuación en el diccionario
    // Usamos como clave del diccionario la fecha de inicio de la partida
    mutableGameResultsFromUserDefaults[[self.start description]] = [self asPropertyList];
    // Guarda el diccionario con el diccionario de las puntuaciones en el UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Convierte el objeto a un PropertyList
- (id) asPropertyList
{
    return @{ START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score) };
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

// El valor de esta propiedad es calculado en tiempo de ejecución
- (NSTimeInterval) duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (void) setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
}
@end
