//
//  Photo+Flickr.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 08/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo+Flickr.h"
#import "FlickrFetcher.h"
#import "Tag+Create.h"

@implementation Photo (Flickr)


+ (Photo *) photoWithFlickrInfo:(NSDictionary *)photoDictionary
                   excludedTags:(NSArray *)excludedTags
         inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    
    // Comprueba si existe el elemento en la BBDD
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"key = %@", [photoDictionary[FLICKR_PHOTO_ID] description]];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches) {
        NSLog(@"Error al relizar consultar a la BBDD: %@", [error localizedDescription]);
    } else if ([matches count] > 1) {
        NSLog(@"Error en la BBDD, existe más de una foto para el identificador único '%@'", photoDictionary[FLICKR_PHOTO_ID]);
    } else if ([matches count] == 0) {
        // La imagen no se encuentra en la BBDD, crea el objeto
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        
        photo.key = [photoDictionary[FLICKR_PHOTO_ID] description];
        photo.title = [photoDictionary[FLICKR_PHOTO_TITLE] description];
        photo.subtitle = [[photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description];
        photo.imageURL = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
        photo.thumbnailURLString = [[FlickrFetcher urlForPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
        
        // Crea los tags y los relaciona con las fotos
        NSArray *aTags = [[photoDictionary[FLICKR_TAGS] description] componentsSeparatedByString:@" "];
        for (NSString *tagTitle in aTags) {
            // Si el tag no es de los excluidos, lo inserta
            if (![excludedTags containsObject:tagTitle]) {
                Tag *tag = [Tag tagWithTitle:tagTitle inManagedObjectContext:context];
                [photo addTagsObject:tag];
            }
        }
    } else {
        // La imagen ya se encuentra en la BBDD, la devuelve
        photo = [matches lastObject];
    }
    
    return photo;
}

@end
