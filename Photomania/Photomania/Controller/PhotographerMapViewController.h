//
//  PhotographerMapViewController.h
//  Photomania
//
//  Created by David Muñoz Fernández on 05/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "MapViewController.h"

@interface PhotographerMapViewController : MapViewController

// Especifica el contexto de la BBDD a la que conectar para obtener los fotógrafos
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// Recarga los datos de la bbdd
- (void) reload;

@end
