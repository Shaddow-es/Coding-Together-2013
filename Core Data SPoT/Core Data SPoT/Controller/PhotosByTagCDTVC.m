//
//  PhotosByTagCDTVC.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 10/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotosByTagCDTVC.h"

@interface PhotosByTagCDTVC ()

@end

@implementation PhotosByTagCDTVC


// ---------------------------------------
//  -- Privated Methods
// ---------------------------------------
#pragma mark - Privated Methods

- (void) setupFetchedResultsController
{
    // Si el tag o su contexto no son nil
    if (self.managedObjectContext){
        // Genera la petición para la BBDD
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Photo"];
        // Establece la condicion
        request.predicate = [NSPredicate predicateWithFormat:@"%@ in tags", self.tag];
        // Establece el orden
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title"
                                                                  ascending:YES
                                                                   selector:@selector(localizedCaseInsensitiveCompare:)]];
        // Establece el fetResultsController
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:self.managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setTag:(Tag *)tag
{
    _tag = tag;
    self.managedObjectContext = tag.managedObjectContext;
    
    // Establece el título del controlador
    self.title = [tag.title capitalizedString];
    // Configura el fetchedResultController para obtener las imágenes por el tag indicado
    [self setupFetchedResultsController];
}
@end
