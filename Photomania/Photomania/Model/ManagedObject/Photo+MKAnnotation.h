//
//  Photo+MKAnnotation.h
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo.h"
#import <MapKit/MapKit.h>

@interface Photo (MKAnnotation) <MKAnnotation>

- (UIImage *) thumbnail; // Bloquea el thread principal (UI)

@end
