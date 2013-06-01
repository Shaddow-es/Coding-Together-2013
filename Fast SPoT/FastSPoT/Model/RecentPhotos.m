//
//  RecentPhotos.m
//  SPoT
//
//  Created by David Muñoz Fernández on 19/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "RecentPhotos.h"

// ---------------------------------------
//  -- Constants
// ---------------------------------------
#pragma mark - Constants

#define SPOT_RECENT_PHOTOS_KEY          @"SpotRecentPhotos"

@implementation RecentPhotos

+ (NSArray *) photos
{
    NSArray *photosData = [self getPhotosFromUserDefaults];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSData *photoData in photosData) {
        [photos addObject:(Photo *) [NSKeyedUnarchiver unarchiveObjectWithData:photoData]];
    }
    return photos;
}

+ (void) addPhoto:(Photo *)photo
{
    [self addPhotoToPhotosFromUserDefaults:photo];
}


// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private methods

// Obtiene una copia del array con las fotos recientes del UserDefaults
+ (NSMutableArray *) getPhotosFromUserDefaults
{
    NSMutableArray *photos = [[[NSUserDefaults standardUserDefaults] arrayForKey:SPOT_RECENT_PHOTOS_KEY] mutableCopy];
    if (!photos) {
        photos = [[NSMutableArray alloc] init];
    }
    return photos;
}

+ (void) addPhotoToPhotosFromUserDefaults:(Photo *) photo
{
    NSMutableArray *photosData = [self getPhotosFromUserDefaults];
    NSData *photoData = [NSKeyedArchiver archivedDataWithRootObject:photo];
    
    // Comprueba si la fotografía existe en el listado de recientes
    NSArray *photos = [self photos];
    NSUInteger index = [photos indexOfObject:photo];
    if (index != NSNotFound) {
        [photosData removeObjectAtIndex:index];
    }
    // Inserta la imagen al array en la primera posición
    [photosData insertObject:photoData atIndex:0];
    // Si se supera el número máximo de elementos borra el último
    if ([photosData count] > MAX_PHOTO_SAVED) {
        [photosData removeLastObject];
    }
    
    // Guarda el array modificado en el UserDefaults
    [[NSUserDefaults standardUserDefaults] setObject:photosData forKey:SPOT_RECENT_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

