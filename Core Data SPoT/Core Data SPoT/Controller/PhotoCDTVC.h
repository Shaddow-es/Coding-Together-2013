//
//  PhotoCDTVC.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 11/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CoreDataTableViewController.h"

@interface PhotoCDTVC : CoreDataTableViewController

// Especifica el contexto de la BBDD a la que conectar para obtener las fotografías
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
