//
//  FlickrPhotoTagsViewController.m
//  SPoT
//
//  Created by David Muñoz Fernández on 16/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "FlickrPhotoTagsViewController.h"
#import "FlickrFetcher.h"
#import "Photo.h"
#import "FlickrPhotoByTagViewController.h"

@interface FlickrPhotoTagsViewController ()

// Array de fotografías obtenidas de flckr
@property (strong, nonatomic) NSMutableArray *photos; // of Photo
// Diccionario de tags: clave es el tag y valor es un array de fotografías que contienen ese tag
@property (strong, nonatomic) NSMutableDictionary *dictPhotosByTag;

@end

@implementation FlickrPhotoTagsViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath){
        if ([segue.identifier isEqualToString:@"setPhotos:"]) {
            // Obtiene el tag seleccionado
            NSString *tag = [self getTagForIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)]) {
                NSArray *photos = [self.dictPhotosByTag objectForKey:tag];
                [segue.destinationViewController performSelector:@selector(setPhotos:)
                                                      withObject:[photos sortedArrayUsingSelector:@selector(titleCompare:)]];
            }
            // Establece el título del controlador de destino
            ( (UIViewController *)segue.destinationViewController).title = [tag capitalizedString];
        }
    }
}

// ---------------------------------------
//  -- Protocol UITableViewDataSource
// ---------------------------------------
#pragma mark - Protocol UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dictPhotosByTag count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Establece los atributos de la celda
    NSString *tag = [self getTagForIndexPath:indexPath];
    cell.textLabel.text = [tag capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d fotografías", [((NSArray *)[self.dictPhotosByTag objectForKey:tag]) count]];
    
    return cell;
}

// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - privated methods

- (NSString *) getTagForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keysOrdered = [[self.dictPhotosByTag allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return keysOrdered[indexPath.row];
}

// Conecta con Flickr y obtiene un listado de todas las fotografías de standford
- (void) reload
{
    // Obtiene la información de flickr
    NSArray *photosDict = [FlickrFetcher stanfordPhotos];
    for (NSDictionary *photoDict in photosDict) {
        // Obtiene el modelo/bean de la foto
        Photo *photo = [Photo photoFromFlickr:photoDict];
        // Filtra los tags de la fotografía eliminando los que no son necsarios
        [photo filterTags:[self tagsToFilter]];
        // Añade la foto al listado de fotos
        [self.photos addObject:photo];
        // Procesa los tag de la fotografía para actualizar el contador de tags
        [self processTagsOf:photo];
    }
    // Ordena el diccionario de 
}

// Procesa los tags de la fotografía y actualiza el contador
- (void) processTagsOf:(Photo *)photo{
    for (NSString *tag in photo.tags) {
        NSMutableArray *photosByTag = [self.dictPhotosByTag objectForKey:tag];
        if (photosByTag) {
            [photosByTag addObject:photo];
        } else {
            photosByTag = [NSMutableArray arrayWithObject:photo];
        }
        [self.dictPhotosByTag setObject:photosByTag forKey:tag];
    }
}

// Array con los tags que no queremos mostrar en el listado
- (NSArray *) tagsToFilter
{
    return @[@"cs193pspot",@"portrait",@"landscape"];
}

// ---------------------------------------
//  -- Getters/Setters methods
// ---------------------------------------
#pragma mark - getters/setters methods

- (NSMutableArray *) photos
{
    if (!_photos){
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSMutableDictionary *) dictPhotosByTag
{
    if (!_dictPhotosByTag){
        _dictPhotosByTag = [[NSMutableDictionary alloc] init];
    }
    return _dictPhotosByTag;
}

@end
