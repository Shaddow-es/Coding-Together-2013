//
//  Photo+Flickr.h
//  Photomania
//
//  Created by David Muñoz Fernández on 04/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *) photoWithFlickrInfo:(NSDictionary *)photoDictionary
         inManagedObjectContext:(NSManagedObjectContext *)context;

@end
