//
//  Photo.h
//  SPoT
//
//  Created by David Muñoz Fernández on 16/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject <NSCoding>

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSArray *tags; // of NSString
@property (strong, nonatomic) NSURL *imageURL;

// Dado un diccionario con las propiedades de flicker construye un objeto foo
+ (Photo *) photoFromFlickr:(NSDictionary *)flickrData;

// Elimina de la fotografía los tags indicados en el array
- (void) filterTags:(NSArray *)tags;

// Compara los títulos de 2 fotografías (ordenación de arrays)
- (NSComparisonResult)titleCompare:(Photo *)photo;
@end
