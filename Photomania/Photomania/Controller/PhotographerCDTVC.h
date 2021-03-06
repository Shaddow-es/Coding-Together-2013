//
//  PhotographerCDTVC.h
//  Photomania
//
//  Created by David Muñoz Fernández on 04/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//
//  Can do "setPhotographer:" segue and will call said method in destination VC.

#import "CoreDataTableViewController.h"

@interface PhotographerCDTVC : CoreDataTableViewController

// Especifica el contexto de la BBDD a la que conectar para obtener los fotógrafos
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
