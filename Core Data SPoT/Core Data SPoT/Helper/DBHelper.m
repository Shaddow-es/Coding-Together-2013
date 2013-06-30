//
//  DBHelper.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 12/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "DBHelper.h"

@interface DBHelper ()

@property (strong, nonatomic) NSString *databaseName;
@property (nonatomic, strong) NSURL *url;

@end

@implementation DBHelper

// ---------------------------------------
//  -- Singleton
// ---------------------------------------
#pragma mark - Singleton

+ (DBHelper *) sharedDBHelper
{
    
    static DBHelper *shared = nil;
    if (!shared) {
        // Si hay múltiples threads intentando acceder a esto, evitamos condiciones de carrera
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[DBHelper alloc] init];
        });
    }
    return shared;
}

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

- (void) openDocumentWithBlock:(void (^)(BOOL))block
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.url path]]) {
        // El documento no existe -> lo crea
        [self.managedDocument saveToURL:self.url
                       forSaveOperation:UIDocumentSaveForCreating
                      completionHandler:block];
    } else if (self.managedDocument.documentState == UIDocumentStateClosed) {
        // Existe pero está cerrado -> lo abre
        [self.managedDocument openWithCompletionHandler:block];
    } else {
        // Ya está abierto y listo para usarse -> ejecuta el bloque
        block(YES);
    }
}

// Guarda el documento
- (void) saveDocument
{
    [self.managedDocument saveToURL:self.url forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (NSString *) databaseName
{
    if (!_databaseName) {
        _databaseName = DATABASE_NAME;
    }
    return _databaseName;
}

- (UIManagedDocument *) managedDocument
{
    if (!_managedDocument) {
        _managedDocument = [[UIManagedDocument alloc] initWithFileURL:self.url];
    }
    return _managedDocument;
}

- (NSURL *) url{
    if (!_url) {
        _url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        _url = [_url URLByAppendingPathComponent:self.databaseName];
    }
    return _url;
}

@end
