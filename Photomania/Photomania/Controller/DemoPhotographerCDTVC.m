//
//  DemoPhotographerCDTVC.m
//  Photomania
//
//  Created by David Muñoz Fernández on 04/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "DemoPhotographerCDTVC.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"

@implementation DemoPhotographerCDTVC


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

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Asocia el target del control de refresco de la tabla a la acción refresh
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
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
}


// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

- (IBAction) refresh
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t fetchQ = dispatch_queue_create("Flickr Fetch", NULL);
    dispatch_async(fetchQ, ^{
        //NSArray *photos = [FlickrFetcher latestGeoreferencedPhotos];
        NSArray *photos = [self fetchLocalPhotos];
        // Todas las operaciones con COREDATA deben hacerse en el thread en el que se creó el contexto
        [self.managedObjectContext performBlock:^{
            // Almacena las fotografías en la bbdd
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo inManagedObjectContext:self.managedObjectContext];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}


// ---------------------------------------
//  -- Alternativa a Flickr para probar sin conexión
// ---------------------------------------
#pragma mark - Alternativa a Flickr para probar sin conexión

- (NSArray *) fetchLocalPhotos
{
    // carga un listado de fotos a manubrio
    [NSThread sleepForTimeInterval:2.0];
    NSMutableArray *aPhotos = [[NSMutableArray alloc] init];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]
                                  unique:@"id1"
                             description:@"Descripción de la foto 1"]];
    [aPhotos addObject:[self createPhoto:@"Super Creppe"
                                   owner:@"Javier Trincado"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/crepe.jpg"]
                                  unique:@"id2"
                             description:@"Descripción de la foto 2"]];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel2"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]
                                  unique:@"id3"
                             description:@"Descripción de la foto 3"]];
    [aPhotos addObject:[self createPhoto:@"Super Creppe2"
                                   owner:@"Javier Trincado"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/crepe.jpg"]
                                  unique:@"id4"
                             description:@"Descripción de la foto 4"]];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel3"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]
                                  unique:@"id5"
                             description:@"Descripción de la foto 5"]];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel4"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]
                                  unique:@"id6"
                             description:@"Descripción de la foto 6"]];
    return (NSArray *) aPhotos;
}

- (NSDictionary *) createPhoto:(NSString *)title
                         owner:(NSString *)owner
                          path:(NSURL *)path
                        unique:(NSString *)unique
                        description:(NSString *)description
{
    
    NSMutableDictionary *photo = [[NSMutableDictionary alloc] init];
    [photo setObject:title forKey:FLICKR_PHOTO_TITLE];
    [photo setObject:description forKey:FLICKR_PHOTO_DESCRIPTION];
    [photo setObject:owner forKey:FLICKR_PHOTO_OWNER];
    [photo setObject:path forKey:@"PATH"];
    [photo setObject:unique forKey:FLICKR_PHOTO_ID];
    return photo;
}

@end
