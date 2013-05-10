//
//  PhotosByPhotographerCDTVC.h
//  Photomania
//
//  Created by David Muñoz Fernández on 04/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Photographer.h"

@interface PhotosByPhotographerCDTVC : CoreDataTableViewController

// Especifica el fotógrafo del que cargar las fotografías
@property (nonatomic, strong) Photographer *photographer;

@end
