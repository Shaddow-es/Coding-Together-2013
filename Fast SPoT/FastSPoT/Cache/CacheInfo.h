//
//  CacheInfo.h
//  SPoT
//
//  Created by David Muñoz Fernández on 28/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheInfo : NSObject <NSCoding>

@property (nonatomic, strong) NSDate *lastAccess;   // Fecha del último acceso
@property (nonatomic, strong) NSDate *dateCreated;  // Fecha de creación
@property (nonatomic, strong) NSNumber *size;       // Tamaño en bytes


// Constructores
+ (CacheInfo *) cacheInfoWithKey:(id)key andSize:(NSInteger)size;

@end
