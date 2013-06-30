//
//  Tag+Create.h
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 08/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)

// Constructor de un tag desde su titulo en la BBDD
// Antes de crear el objeto comprueba si ya existe, en ese caso devuelve el de la BBDD
+ (Tag *) tagWithTitle:(NSString *)title
        inManagedObjectContext:(NSManagedObjectContext *)context;

@end
