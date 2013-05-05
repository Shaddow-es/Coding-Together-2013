//
//  Photographer+Create.h
//  Photomania
//
//  Created by David Muñoz Fernández on 04/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "Photographer.h"

@interface Photographer (Create)

+ (Photographer *) photographerWithName:(NSString *)name
                 inManagedObjectContext:(NSManagedObjectContext *)context;
@end
