//
//  LatestFlickrPhotosTVC.m
//  Shutterbug
//
//  Created by David Muñoz Fernández on 02/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "LatestFlickrPhotosTVC.h"
#import "FlickrFetcher.h"

@interface LatestFlickrPhotosTVC ()

@end

@implementation LatestFlickrPhotosTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.photos = [FlickrFetcher latestGeoreferencedPhotos];
    
    // carga un listado de fotos a manubrio
    NSMutableArray *aPhotos = [[NSMutableArray alloc] init];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]]];
    [aPhotos addObject:[self createPhoto:@"Super Creppe"
                                   owner:@"Javier Trincado"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/crepe.jpg"]]];
    self.photos = aPhotos;
}

- (NSDictionary *) createPhoto:(NSString *)title owner:(NSString *)owner path:(NSURL *)path
{
    
    NSMutableDictionary *photo = [[NSMutableDictionary alloc] init];
    [photo setObject:title forKey:FLICKR_PHOTO_TITLE];
    [photo setObject:owner forKey:FLICKR_PHOTO_OWNER];
    [photo setObject:path forKey:@"PATH"];
    return photo;
}

@end
