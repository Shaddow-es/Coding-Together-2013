//
//  DemoPhotographerMapViewController.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "DemoPhotographerMapViewController.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@implementation DemoPhotographerMapViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Si el contexto no existe, lo carga
    // -- Lo hace en willapper en vez de viewdidload para asegurarse que no lo hace si no es necesario
    //    + Hace una conexión a internet y no es gratis, solo hacerlo si realmente el controller es visible
    //    + Podría no ser necesario pq el controller no se hace visible
    //      Por este motivo mejor que en el viewDidLoad (siempre se carga pero no siempre tiene pq ser visible)
    if (!self.managedObjectContext) {
        [self useDemoDocument];
    }
}

// ---------------------------------------
//  -- Privated Methods
// ---------------------------------------
#pragma mark - Privated Methods

- (void) useDemoDocument
{
    // Genera la url en la que guarda la bbdd de fotógrafos
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    url = [url URLByAppendingPathComponent:@"Demo Document"];
    // Obtiene el ManagedDocument para la ruta escogida
    UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        // El documento no existe -> lo crea
        [document saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.managedObjectContext = document.managedObjectContext;
                  [self refresh];
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        // Existe y está cerrado -> lo abre
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.managedObjectContext = document.managedObjectContext;
            }
        }];
    } else {
        // Existe y no está cerrado -> intenta utilizarlo
        self.managedObjectContext = document.managedObjectContext;
    }
    [self refresh];
}


// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

- (IBAction) refresh
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
        // Todas las operaciones con COREDATA deben hacerse en el thread en el que se creó el contexto
        [self.managedObjectContext performBlock:^{
            // Almacena las fotografías en la bbdd
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self reload];
            });
        }];
    });
}


@end
