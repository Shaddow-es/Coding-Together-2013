//
//  TagCDTVC.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 09/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

//  Puede hacer la segue "setTag:" y llamará al método especificado en el VC destinatario

#import "CoreDataTableViewController.h"

@interface TagCDTVC : CoreDataTableViewController

// Especifica el contexto de la BBDD a la que conectar para obtener los tags
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
