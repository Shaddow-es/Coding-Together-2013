//
//  PhotoViewController.m
//  Photomania
//
//  Created by David Muñoz Fernández on 10/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotoViewController.h"
#import "MapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotoViewController ()

@property (nonatomic,strong) MapViewController *mapvc;

@end

@implementation PhotoViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Embed Map of Photo"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            self.mapvc = segue.destinationViewController;
        }
    }
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.mapvc.mapView addAnnotation:self.photo];
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setPhoto:(Photo *)photo
{
    _photo = photo;
    self.title = self.photo.title;
    self.imageURL = [NSURL URLWithString:photo.imageURL];
}
@end
