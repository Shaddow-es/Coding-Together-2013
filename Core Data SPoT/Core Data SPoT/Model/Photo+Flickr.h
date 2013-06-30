//
//  Photo+Flickr.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 08/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

// Constructor de Photo desde diccionario con los metadatods de una imagen obtenido de API Flickr
+ (Photo *) photoWithFlickrInfo:(NSDictionary *)photoDictionary
                   excludedTags:(NSArray *)excludedTags
         inManagedObjectContext:(NSManagedObjectContext *)context;
@end
