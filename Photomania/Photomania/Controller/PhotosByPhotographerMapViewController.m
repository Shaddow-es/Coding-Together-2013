//
//  PhotosByPhotographerMapViewController.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotosByPhotographerMapViewController.h"
#import "Photo+MKAnnotation.h"

@interface PhotosByPhotographerMapViewController ()

@end

@implementation PhotosByPhotographerMapViewController


// ---------------------------------------
//  -- MKMapViewDelegate protocol
// ---------------------------------------
#pragma mark - MKMapViewDelegate protocol

// Ejecutado cuando se pulsa en el botón de disclosure indicadtor del calloutAccesory
- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhoto:" sender:view];
}

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"setPhoto:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = (MKAnnotationView *) sender;
            if ([aView.annotation isKindOfClass:[Photo class]]) {
                Photo *photo = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhoto:)]) {
                    [segue.destinationViewController performSelector:@selector(setPhoto:) withObject:photo];
                }
            }
        }
    }
}

// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - Privated methods

- (void) reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    // muestra los fotografías del fotógrafo
    request.predicate = [NSPredicate predicateWithFormat:@"whoTook = %@", self.photographer];
    NSArray *photos = [self.photographer.managedObjectContext executeFetchRequest:request error:NULL];
    // elimina las anotaciones que tuviese el mapa y añade las nuevas
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photos];
    // Centra el mapa en una de las fotos
    Photo *photo = [photos lastObject];
    if (photo) {
        self.mapView.centerCoordinate = photo.coordinate;
    }
}


// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setPhotographer:(Photographer *)photographer
{
    _photographer = photographer;
    self.title = photographer.name;
    // Si la vista es visible -> recarga los datos
    if (self.view.window) {
        [self reload];
    }
}

@end
