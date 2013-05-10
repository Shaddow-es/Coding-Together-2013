//
//  Photo+MKAnnotation.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photo+MKAnnotation.h"

@implementation Photo (MKAnnotation)

- (CLLocationCoordinate2D) coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.latitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

- (UIImage *) thumbnail
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.thumbnailURLString]]];
}

@end
