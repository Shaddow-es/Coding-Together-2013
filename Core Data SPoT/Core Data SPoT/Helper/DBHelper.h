//
//  DBHelper.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 12/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBHelper : NSObject

// ---------------------------------------
//  -- Constantes
// ---------------------------------------
// Nombre de fichero donde almacena la bbdd
#define DATABASE_NAME     @"Flickr Photos BBDD"

// ---------------------------------------
//  -- Propiedades públicas
// ---------------------------------------
@property (nonatomic, strong) UIManagedDocument *managedDocument;

// ---------------------------------------
//  -- Métodos
// ---------------------------------------

// Singleton
+ (DBHelper *) sharedDBHelper;

// Abre el documento y ejecuta el bloque
- (void) openDocumentWithBlock:(void (^)(BOOL))block;
// Guarda el documento
- (void) saveDocument;

@end
