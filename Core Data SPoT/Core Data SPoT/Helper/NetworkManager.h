//
//  NetworkManager.h
//  SPoT
//
//  Created by David Muñoz Fernández on 21/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

// -- La clase se encarga de llegar un contador con el número de conexiones de datos pendientes
// -- Cuando hay alguna petición pendiente activa el indicador de actividad de red
// -----------------------------------------------

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

// Método a llamar cuando se comienza una nueva petición de red
+ (void) downloadStarted;
// Método a llamar cuando se finaliza una petición de red
+ (void) downloadFinished;

@end
