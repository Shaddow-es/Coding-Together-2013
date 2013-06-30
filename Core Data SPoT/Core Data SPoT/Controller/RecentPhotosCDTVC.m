//
//  RecentPhotosCDTVC.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 11/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "DBHelper.h"

@interface RecentPhotosCDTVC ()

@end

@implementation RecentPhotosCDTVC


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

// ---------------------------------------
//  -- Privated Methods
// ---------------------------------------
#pragma mark - Privated Methods

- (void) useDataDocument
{
    [[DBHelper sharedDBHelper] openDocumentWithBlock:^(BOOL success) {
        if (success) {
            self.managedObjectContext = [DBHelper sharedDBHelper].managedDocument.managedObjectContext;
            [self setupFetchedResultsController];
        }
    }];
}

#define MAX_RECENT_RESULTS 20
- (void) setupFetchedResultsController
{
    // Si el tag o su contexto no son nil
    if (self.managedObjectContext){
        // Genera la petición para la BBDD
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
        // Establece el número máximo de resultados
        request.fetchLimit = MAX_RECENT_RESULTS;
        request.predicate = [NSPredicate predicateWithFormat:@"lastAccess != NULL"];
        // Establece el orden
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastAccess"
                                                                  ascending:NO
                                                                   selector:nil]];
        // Establece el fetResultsController
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
