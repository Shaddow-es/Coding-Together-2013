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

// Actualiza la puntuación en el diccionario de resultados de UserDefaults
- (void) saveScoresInUserDefaults;

@property (readonly, nonatomic) NSDate *start;
@property (readonly, nonatomic) NSDate *end;
// Propiedad calculada en tiempo de ejecución
@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int score;

@end
