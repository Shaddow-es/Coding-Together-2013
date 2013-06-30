//
//  Tag+Create.m
//  Core Data SPoT
//
//  Created by David Muñoz Fernández on 08/06/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Tag+Create.h"

@implementation Tag (Create)

+ (Tag *) tagWithTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    
    // Comprueba si existe el elemento en la BBDD
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches) {
        NSLog(@"Error al relizar consultar a la BBDD: %@", [error localizedDescription]);
    } else if ([matches count] > 1) {
        NSLog(@"Error en la BBDD, existe más de un tag para el título '%@'", title);
    } else if ([matches count] == 0){
        // El tag no se encuentra en la BBDD, crea el objeto
        tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
        tag.title = title;
    } else {
        // Un único resultado -> devuelve el objeto
        tag = [matches lastObject];
    }
    
    return tag;
}

@end
