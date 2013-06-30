//
//  NSDataCache.h
//  SPoT
//
//  Created by David Muñoz Fernández on 26/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>


// -- Cache en dico de elementos NSData
// --   La cache almacena los datos (NSData) en disco, no en memoria
// --   Cuando la cache supera el tamaño máximo, elimina los elementos accedidos hace más tiempo
// --   La cache elimina los elementos que hayan expirado (tiempo transcurrido desde la creación mayor al permitido)
// --   La clave que identifica el elemento de la cache debe ser única por elemento e impelementar el método "description"
// ---------------------------------------------------------------------------------------------

@interface NSDataCache : NSObject

// ---------------------------------------
//  -- Constantes
// ---------------------------------------
// Clave en la que se almacena en el userdefaults los metadatos de la cache
#define KEY_USER_DEFAULTS_CACHE     @"SpotUserDefaultsCache"

// Tiempo en segundos para que la cache expire
#define CACHE_EXPIRATION_SECONDS    15*60       // 15 minutos
// Tamaño máximo de la cache en bytes (Si es un iPad el tamaño se multiplica por el factor)
#define CACHE_MAX_SIZE              3*1024*1024 // 3 MB
#define CACHE_MAX_SIZE_IPAD_FACTOR  3           // Si es un iPad el tamaño de la caché es multiplicado por este factor

// ---------------------------------------
//  -- Propiedades
// ---------------------------------------
@property (nonatomic) NSUInteger maxCacheSize;      // en bytes
@property (nonatomic) NSUInteger maxCacheDuration;  // en segundos

// ---------------------------------------
//  -- Métodos
// ---------------------------------------

// Singleton
+ (NSDataCache *) sharedNSDataCache;

// Añade un elememento nuevo en la cache
//   Actualiza la fecha de acceso en la cache en caso de existir
- (void) addData:(NSData *)data withKey:(id)key;

// Obtiene un elemento de la cache
//   En caso de no existir en la cache devuelve nil
//   Actualiza la fecha de acceso en la cache en caso de existir
- (NSData *) getData:(id)key;

@end
