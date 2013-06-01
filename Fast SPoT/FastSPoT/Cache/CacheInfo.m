//
//  CacheInfo.m
//  SPoT
//
//  Created by David Muñoz Fernández on 28/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CacheInfo.h"

@implementation CacheInfo

// ---------------------------------------
//  -- Constructores
// ---------------------------------------
#pragma mark - Constructores

+ (CacheInfo *) cacheInfoWithKey:(id)key andSize:(NSInteger)size;
{
    CacheInfo *cacheInfo = [[CacheInfo alloc] init];
    NSDate *date = [NSDate date]; // fecha actual
    cacheInfo.lastAccess = date;
    cacheInfo.dateCreated = [date copy];
    cacheInfo.size = [NSNumber numberWithInteger:size];
    return cacheInfo;
}


// ---------------------------------------
//  -- Protocol NSObject
// ---------------------------------------
#pragma mark - Protocol NSObject

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[CacheInfo class]]){
        CacheInfo *cacheInfo = object;
        return [cacheInfo.dateCreated isEqual:self.dateCreated] &&
            [cacheInfo.lastAccess isEqual:self.lastAccess] &&
            [cacheInfo.size isEqual:self.size];
    }
    return false;
}

// ---------------------------------------
//  -- Protocol NSCoding
// ---------------------------------------
#pragma mark - Protocol NSCoding

#define KEY_DATE_LAST_ACCESS    @"lastAccess"
#define KEY_DATE_CREATED        @"created"
#define KEY_SIZE                @"size"
#define KEY_ID                  @"id"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.lastAccess = [aDecoder decodeObjectForKey:KEY_DATE_LAST_ACCESS];
        self.dateCreated = [aDecoder decodeObjectForKey:KEY_DATE_CREATED];
        self.size = [aDecoder decodeObjectForKey:KEY_SIZE];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.lastAccess forKey:KEY_DATE_LAST_ACCESS];
    [aCoder encodeObject:self.dateCreated forKey:KEY_DATE_CREATED];
    [aCoder encodeObject:self.size forKey:KEY_SIZE];
}

@end
