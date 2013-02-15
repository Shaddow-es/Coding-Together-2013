//
//  GameResult.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 09/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject

// Devuelve un array de GameResult con los resultados almacenados en standardUserDefaults
+ (NSArray *) allGameResults; // of GameResult

// Elimina el array de los resultados en StandarUserDefaults
+ (void) resetAllGameResults;

// Actualiza la puntuación en el diccionario de resultados de UserDefaults
- (void) saveScoresInUserDefaults;

// Método de comparación de resultados
- (NSComparisonResult)dateCompare:(GameResult *)gameResult;
- (NSComparisonResult)scoreCompare:(GameResult *)gameResult;
- (NSComparisonResult)durationCompare:(GameResult *)gameResult;

// Propiedades de lectura
@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
@property (readonly, nonatomic) NSTimeInterval duration; // Calculada en ejecución
@property (nonatomic) int score;

@end
