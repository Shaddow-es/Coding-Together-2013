//
//  PhotosByPhotographerMapViewController.h
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "MapViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerMapViewController : MapViewController

// Especifica el fotógrafo del que cargar las fotografías en el mapa
@property (nonatomic, strong) Photographer *photographer;

@end
