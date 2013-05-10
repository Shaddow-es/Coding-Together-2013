//
//  Photographer+MKAnnotation.m
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photographer+MKAnnotation.h"
#import "Photo+MKAnnotation.h"

@implementation Photographer (MKAnnotation)

- (NSString *) title
{
    return self.name;
}

- (NSString *) subtitle
{
    return [NSString stringWithFormat:@"%d fotografías", [self.photos count]];
}

- (CLLocationCoordinate2D) coordinate
{
    return [[self.photos anyObject] coordinate];
}

- (UIImage *) thumbnail
{
    return [[self.photos anyObject] thumbnail];
}

@end
