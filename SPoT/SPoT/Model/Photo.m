//
//  Photo.m
//  SPoT
//
//  Created by David Muñoz Fernández on 16/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo.h"
#import "FlickrFetcher.h"

@implementation Photo

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

+ (Photo *) photoFromFlickr:(NSDictionary *)flickrData
{
    Photo *photo = [[Photo alloc] init];
    photo.id = [flickrData[FLICKR_PHOTO_ID] description];
    photo.title = [flickrData[FLICKR_PHOTO_TITLE] description];
    photo.description = [flickrData valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    photo.tags = [[flickrData[FLICKR_TAGS] description] componentsSeparatedByString:@" "];
    photo.imageURL = [FlickrFetcher urlForPhoto:flickrData format:FlickrPhotoFormatLarge];
    return photo;
}

- (void) filterTags:(NSArray *)tags
{
    NSMutableArray *maTags = [NSMutableArray arrayWithArray:self.tags];
    for (NSString *tag in tags) {
        [maTags removeObject:tag];
    }
    self.tags = maTags;
}


- (NSComparisonResult)titleCompare:(Photo *)photo
{
    return [self.title compare:photo.title];
}


// ---------------------------------------
//  -- Protocol NSObject
// ---------------------------------------
#pragma mark - Protocol NSObject

// Dos fotografías son iguales si tienen el mismo id
- (BOOL) isEqual:(id)object
{
    Photo *photo = object;
    return [self.id isEqual:photo.id];
}


// ---------------------------------------
//  -- Protocol NSCoding
// ---------------------------------------
#pragma mark - Protocol NSCoding

#define KEY_PHOTO_ID            @"id"
#define KEY_PHOTO_TITLE         @"title"
#define KEY_PHOTO_DESCRIPTION   @"description"
#define KEY_PHOTO_TAGS          @"tags"
#define KEY_PHOTO_URL           @"url"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.id = [aDecoder decodeObjectForKey:KEY_PHOTO_ID];
        self.title = [aDecoder decodeObjectForKey:KEY_PHOTO_TITLE];
        self.description = [aDecoder decodeObjectForKey:KEY_PHOTO_DESCRIPTION];
        self.tags = [aDecoder decodeObjectForKey:KEY_PHOTO_TAGS];
        self.imageURL = [aDecoder decodeObjectForKey:KEY_PHOTO_URL];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.id forKey:KEY_PHOTO_ID];
    [aCoder encodeObject:self.title forKey:KEY_PHOTO_TITLE];
    [aCoder encodeObject:self.description forKey:KEY_PHOTO_DESCRIPTION];
    [aCoder encodeObject:self.tags forKey:KEY_PHOTO_TAGS];
    [aCoder encodeObject:self.imageURL forKey:KEY_PHOTO_URL];
}

@end
