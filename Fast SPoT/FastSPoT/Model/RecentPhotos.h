//
//  RecentPhotos.h
//  SPoT
//
//  Created by David Muñoz Fernández on 19/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photo.h"

// -- Almacena un listado de las últimas fotografías visitadas
// --  Guarda el resultado en el NSUserDefaults
// -----------------------------------------
@interface RecentPhotos : NSObject

#define MAX_PHOTO_SAVED 15 // Número máximo de fotografías que son almacenadas

// Devuelve todas las fotografías
+ (NSArray *) photos; // of Photo

// Añade una fotografía al array de fotografías
//  Las ordena por orden de uso, la última añadida es la primera de la lista
//  En caso de ya existir la mueve a la primera posición
//  Si se ha superado el número máximo de fotografías a salvar, elimina la añadida hace más tiempo
+ (void) addPhoto:(Photo *)photo;

@end
