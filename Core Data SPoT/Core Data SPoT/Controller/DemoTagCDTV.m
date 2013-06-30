//
//  DemoTagCDTV.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 10/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "DemoTagCDTV.h"
#import "NetworkManager.h"
#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "DBHelper.h"

@interface DemoTagCDTV ()

@end

@implementation DemoTagCDTV


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Carga la BBDD cuando aún no está carga
    //   - La operación mejor hacerla aquí que en el viewDidLoad para realizarla solo cuando va a aparecer en pantalla
    //   - En caso de que nunca aparezca nos lo ahorramos (conexión a internet es caro)
    if (!self.managedObjectContext) {
        [self useDataDocument];
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Asocia el target del control de refresco de la tabla al método refresh
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

// ---------------------------------------
//  -- Privated Methods
// ---------------------------------------
#pragma mark - Privated Methods

// Array con los tags que no queremos mostrar en el listado
- (NSArray *) tagsToFilter
{
    return @[@"cs193pspot",@"portrait",@"landscape"];
}

- (void) useDataDocument
{
    
    [[DBHelper sharedDBHelper] openDocumentWithBlock:^(BOOL success) {
        if (success) {
            self.managedObjectContext = [DBHelper sharedDBHelper].managedDocument.managedObjectContext;
        }
    }];
}

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

#define QUEUE_FLICKR_FETCHER "flickr fetcher"

- (IBAction) refresh
{
    // Marca el control de actualización como activo
    [self.refreshControl beginRefreshing];
    // Obtiene la información de flickr (en otro thred)
    dispatch_queue_t imageFetcherQ = dispatch_queue_create(QUEUE_FLICKR_FETCHER, NULL);
    dispatch_async(imageFetcherQ, ^{
        [NetworkManager downloadStarted];
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        [NetworkManager downloadFinished];
        
        // Las operaciones CORE DATA se hacen en el thread al que pertenece el contexto
        [self.managedObjectContext performBlock:^{
            // Almacena ls fotografías en la BBDD
            for (NSDictionary *photo in photos) {
                [Photo photoWithFlickrInfo:photo
                              excludedTags:[self tagsToFilter]
                    inManagedObjectContext:self.managedObjectContext];
            }
            
            // Guarda la BBDD de forma explícita
            [[DBHelper sharedDBHelper] saveDocument];
            
            // Los cambios en la UI los realiza en el thread principal
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.refreshControl endRefreshing];
            });
        }];
    });
}

@end
