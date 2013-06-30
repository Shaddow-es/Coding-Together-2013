//
//  PhotosByTagCDTVC.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 10/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "PhotoCDTVC.h"
#import "Tag.h"

@interface PhotosByTagCDTVC : PhotoCDTVC

// Especifica el tag del que cargar las fotografías
@property (nonatomic, strong) Tag *tag;

@end
