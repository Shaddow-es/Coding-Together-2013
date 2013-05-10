//
//  MapViewController.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController ()

@property (nonatomic) BOOL needUpdateRegion;

@end

@implementation MapViewController

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void) viewDidLoad
{
    [super viewDidLoad];
    // Establece el delegado del mapview a si mismo
    self.mapView.delegate = self;
    // Hace que el mapa haga zoom a la región que contenga todas las anotaciones
    self.needUpdateRegion = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // Al hacer zoom en este método conseguimos el efecto de hacer zoom desde la vista del mundo
    if (self.needUpdateRegion) {
        [self updateRegion];
    }
}

// ---------------------------------------
//  -- Protocol MKMapViewDelegate
// ---------------------------------------
#pragma mark - Protocol MKMapViewDelegate

// Ejecutado cuando el "pin" es pulsado
- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *) view.leftCalloutAccessoryView;
        if ([view.annotation respondsToSelector:@selector(thumbnail)]) {
            imageView.image = [view.annotation performSelector:@selector(thumbnail)];
        } else {
            imageView.image = nil;
        }
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *reuseId = @"MapViewController";
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        // Mostramos información adicional (callout) al pinchar en la anotación del mapa
        view.canShowCallout = YES;
        // Crea la vista de la parte derecha del callout
        if ([mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
            view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        // Crea la vista de la parte izquierda del callout
        view.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    
    // Establece la imagen a nil, en caso de ser reutilizada de la cola
    if ([view.leftCalloutAccessoryView isKindOfClass:[UIImageView class]]){
        UIImageView *imageView = (UIImageView *) view.leftCalloutAccessoryView;
        imageView.image = nil;
    }
    
    return view;
}


// ---------------------------------------
//  -- Privated methods
// ---------------------------------------
#pragma mark - Privated methods

- (void) updateRegion
{
    self.needUpdateRegion = NO;
    
    // En esta variable almacena el cuadrado que aglutina todas las posiciciones de todas la anotaciones
    CGRect boundingRect;
    BOOL started = NO;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        CGRect annotationRect = CGRectMake(annotation.coordinate.latitude, annotation.coordinate.longitude, 0, 0);
        if (!started) {
            started = YES;
            boundingRect = annotationRect;
        } else {
            boundingRect = CGRectUnion(boundingRect, annotationRect);
        }
    }
    if (started) {
        // Aumenta un 20% el tamaño del rectángulo que marca la zona de las anotaciones del mapa
        boundingRect = CGRectInset(boundingRect, -0.2, -0.2);
        if ((boundingRect.size.width < 20) && (boundingRect.size.height < 20)) {
            MKCoordinateRegion region;
            region.center.latitude = boundingRect.origin.x + boundingRect.size.width / 2;
            region.center.longitude = boundingRect.origin.y + boundingRect.size.height / 2;
            region.span.latitudeDelta = boundingRect.size.width;
            region.span.longitudeDelta = boundingRect.size.height;
            [self.mapView setRegion:region animated:YES];
        }
    }
}


@end
