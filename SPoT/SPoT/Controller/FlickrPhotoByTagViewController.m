//
//  FlickrPhotoByTagViewController.m
//  SPoT
//
//  Created by David Muñoz Fernández on 18/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "FlickrPhotoByTagViewController.h"
#import "Photo.h"
#import "FlickrFetcher.h"
#import "RecentPhotos.h"

@interface FlickrPhotoByTagViewController ()

@end

@implementation FlickrPhotoByTagViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath){
        if ([segue.identifier isEqualToString:@"setImageURL:"]) {
            // Obtiene la fotografía seleccionada
            Photo *photo = self.photos[indexPath.row];
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                [segue.destinationViewController performSelector:@selector(setImageURL:)
                                                      withObject:photo.imageURL];
            }
            // Añade la imagen al listado de imágenes recientes
            [RecentPhotos addPhoto:photo];
            // Establece el título del controlador de destino
            ( (UIViewController *)segue.destinationViewController).title = photo.title;
        }
    }
}

// ---------------------------------------
//  -- Protocol UITableViewDataSource
// ---------------------------------------
#pragma mark - Protocol UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"photoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Establece los atributos de la celda
    Photo *photo = self.photos[indexPath.row];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.description;
    
    return cell;
}

@end
