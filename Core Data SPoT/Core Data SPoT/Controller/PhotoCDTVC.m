//
//  PhotoCDTVC.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 11/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotoCDTVC.h"
#import "NetworkManager.h"
#import "Photo.h"
#import "DBHelper.h"

@interface PhotoCDTVC ()

@end

@implementation PhotoCDTVC



// ---------------------------------------
//  -- Table view data source
// ---------------------------------------

#pragma mark - Table view data source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    if (photo.thumbnailData) {
        // Ya tiene descargado el thumbnail de la imagen, lo muestra
        UIImage *image = [[UIImage alloc] initWithData:photo.thumbnailData];
        cell.imageView.image = image;
    } else {
        // No ha descargado el thumbnail de la imagen, lo descarga
        cell.imageView.image = nil;
        dispatch_queue_t thumbanilFetcherQ = dispatch_queue_create("thumbnail fetcher", NULL);
        dispatch_async(thumbanilFetcherQ, ^{
            // Descarga el thumbnail
            [NetworkManager downloadStarted];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURLString]];
            [NetworkManager downloadFinished];
            
            // Guarda el thumbnail en la BBDD
            [photo.managedObjectContext performBlock:^{
                photo.thumbnailData = imageData;
                [photo.managedObjectContext save:nil];
                
                // Guarda la BBDD de forma explícita
                [[DBHelper sharedDBHelper] saveDocument];
            }];
        });
    }
    
    return cell;
}

// ---------------------------------------
//  -- Segue
// ---------------------------------------
#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"setImageURL:"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]){
                Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
                NSURL *url = [NSURL URLWithString:photo.imageURL];
                
                // Actualiza la última fecha de acceso en la BBDD
                [photo.managedObjectContext performBlock:^{
                    photo.lastAccess = [NSDate date];
                    [photo.managedObjectContext save:nil];
                    
                    // Guarda la BBDD de forma explícita
                    [[DBHelper sharedDBHelper] saveDocument];
                }];
                
                [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                // Establece el título del VC destino
                [segue.destinationViewController setTitle:photo.title];
            }
        }
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        // Cuando establece el contexto obtiene un listado de todos los tags de la BBDD
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:managedObjectContext
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
    } else {
        // Si el contexto es nil, limpia el controlador de resultados
        self.fetchedResultsController = nil;
    }
}

@end
