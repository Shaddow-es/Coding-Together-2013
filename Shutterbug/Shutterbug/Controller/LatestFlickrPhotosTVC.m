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
    [self loadLocalPhotos];
    [self.refreshControl addTarget:self
                            action:@selector(loadLocalPhotos)
                  forControlEvents:UIControlEventValueChanged];
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

- (void) loadLocalPhotos {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("local latest loader", NULL);
    dispatch_async(loaderQ, ^{
        [NSThread sleepForTimeInterval:2.0];
        NSArray *latestPhotos = [self fetchLocalPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

- (NSArray *) fetchLocalPhotos
{
    // carga un listado de fotos a manubrio
    NSMutableArray *aPhotos = [[NSMutableArray alloc] init];
    [aPhotos addObject:[self createPhoto:@"Torre Effiel"
                                   owner:@"David Muñoz"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/paris.jpg"]]];
    [aPhotos addObject:[self createPhoto:@"Super Creppe"
                                   owner:@"Javier Trincado"
                                    path:[[NSURL alloc] initFileURLWithPath:@"/Users/dmunoz/Desktop/crepe.jpg"]]];
    return (NSArray *) aPhotos;
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
