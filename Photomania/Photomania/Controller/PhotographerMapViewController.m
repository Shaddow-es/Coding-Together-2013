//
//  PhotographerMapViewController.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotographerMapViewController.h"
#import <CoreData/CoreData.h>
#import "Photographer+MKAnnotation.h"

@implementation PhotographerMapViewController

// ---------------------------------------
//  -- Public methods
// ---------------------------------------
#pragma mark - Public methods

- (void) reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photographer"];
    // muestra los fotógrafos con más de una fotografía
    request.predicate = [NSPredicate predicateWithFormat:@"photos.@count > 2"];
    NSArray *photographers = [self.managedObjectContext executeFetchRequest:request error:NULL];
    // elimina las anotaciones que tuviese el mapa y añade las nuevas
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView addAnnotations:photographers];
}


// ---------------------------------------
//  -- MKMapViewDelegate protocol
// ---------------------------------------
#pragma mark - MKMapViewDelegate protocol

// Ejecutado cuando se pulsa en el botón de disclosure indicadtor del calloutAccesory
- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"setPhotographer:" sender:view];
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
    if ([segue.identifier isEqualToString:@"setPhotographer:"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = (MKAnnotationView *) sender;
            if ([aView.annotation isKindOfClass:[Photographer class]]) {
                Photographer *photographer = aView.annotation;
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotographer:)]) {
                    [segue.destinationViewController performSelector:@selector(setPhotographer:) withObject:photographer];
                }
            }
        }
    }
}

// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    // Recarga si está visible esta vista
    if (self.view.window) {
        [self reload];
    }
}

@end
