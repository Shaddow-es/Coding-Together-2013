//
//  NSDataCache.m
//  SPoT
//
//  Created by David Muñoz Fernández on 26/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "NSDataCache.h"
#import "CacheInfo.h"
#import "NSString+Hashes.h"

@interface NSDataCache ()

// Diccionario que que almacena los metadatos de los NSData a cachear
// Como clave utiliza el identificador/clave
@property (nonatomic, strong) NSMutableDictionary *dicCacheInfo; // of NSData (CacheInfo archivado)

@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *cacheDirectory;
@end


@implementation NSDataCache

@synthesize maxCacheSize = _maxCacheSize;

// ---------------------------------------
//  -- Singleton
// ---------------------------------------
#pragma mark - Singleton

+ (NSDataCache *) sharedNSDataCache
{
    
    static NSDataCache *shared = nil;
    if (!shared) {
        // Si hay múltiples threads intentando acceder a esto, evitamos condiciones de carrera
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            shared = [[NSDataCache alloc] init];
        });
    }
    return shared;
}

// ---------------------------------------
//  -- Métodos públicos
// ---------------------------------------
#pragma mark - Métodos públicos

- (void) addData:(NSData *)data withKey:(id)key
{
    NSString *keyHash = [self stringHashForKey:key];
    // Comprueba si el elemento existe en la cache
    CacheInfo *cacheInfo = [self getCachedInfoForKey:keyHash];
    if (cacheInfo){
        // El elemento existe -> actualiza la fecha de acceso
        cacheInfo.lastAccess = [NSDate date];
        [self saveCacheInfo:cacheInfo forKey:keyHash];
    }else{
        // No existe, lo añade a la cache
        cacheInfo = [CacheInfo cacheInfoWithKey:keyHash andSize:data.length];
        [self saveCacheInfo:cacheInfo forKey:keyHash];
        // Lo almacena en disco
        [self saveDatatoDisk:data forKey:keyHash];
    }
}

- (NSData *) getData:(id)key
{
    // Limpia la cache
    [self cleanCache];
    
    NSData *data = nil;
    NSString *keyHash = [self stringHashForKey:key];
    CacheInfo *cacheInfo = [self getCachedInfoForKey:keyHash];
    if (cacheInfo){
        // El elemento existe -> actualiza la fecha de acceso
        cacheInfo.lastAccess = [NSDate date];
        [self saveCacheInfo:cacheInfo forKey:keyHash];
        // Recupera el NSData del sistema de ficheros
        data = [self fetchDataFromDiskForKey:keyHash];
        if (!data){
            [self deleteCacheForKey:keyHash];
        }
    }
    return data;
}

// ---------------------------------------
//  -- Métodos privados
// ---------------------------------------
#pragma mark - Métodos privados

// Convierte la clave de la cache en un string codificando mediante una función hash
- (NSString *) stringHashForKey:(id)key
{
    return [[key description] sha512];
}

// Obtiene datos del disco 
- (NSData *) fetchDataFromDiskForKey:(id)key
{
    NSString *path = [self.cacheDirectory stringByAppendingPathComponent:key];
    return [NSData dataWithContentsOfFile:path];
}

- (void) removeDataFromDiskForKey:(id)key
{
    NSString *path = [self.cacheDirectory stringByAppendingPathComponent:key];
    if (![self.fileManager removeItemAtPath:path error:nil]){
        NSLog(@"Error removing data from %@", path);
    }
}

// Guarda la información en disco
- (void) saveDatatoDisk:(NSData *)data forKey:(id)key
{
    NSString *path = [self.cacheDirectory stringByAppendingPathComponent:key];
    if (![data writeToFile:path atomically:YES]){
        NSLog(@"Error saving data to %@", path);
    }
}

// Comprueba la cache, eliminando los elementos:
//   + Cache expirada: tiempo transcurrido desde la creación mayor al permitido
//   + Límite de tamaño de caché superado
//        - Elimina los elementos necesarios hasta que el límite no se supere por orden de menos uso
- (void) cleanCache
{
    // Limpia los elementos cacheados expirados
    for (NSString *key in [self.dicCacheInfo allKeys]) {
        CacheInfo *cacheInfo = [self getCachedInfoForKey:key];
        //if ([cacheInfo.lastAccess timeIntervalSinceNow] < -self.maxCacheDuration ){
        if (self.maxCacheDuration < -[cacheInfo.lastAccess timeIntervalSinceNow] ){
            [self.dicCacheInfo removeObjectForKey:key];
        }
    }
    // Elimina los elementos necesarios para no superar el límite de tamaño
    while ([self cacheSize] > CACHE_MAX_SIZE) {
         // Elimina el elemento accedido hace más tiempo
        [self deleteLastAccessed];
    }
}

// Inserta una nueva entrada en la cache
//   Si es necesario elimina los elementos que sean necesarios para no superar los límites
//   Actualiza la información en el NSUserDefaults
- (void) saveCacheInfo:(CacheInfo *)cacheInfo forKey:(id)key
{
    // Convierte el cacheInfo a NSData
    NSData *cacheInfoData = [NSKeyedArchiver archivedDataWithRootObject:cacheInfo];
    [self.dicCacheInfo setObject:cacheInfoData forKey:key];
    // Limpia la cache (expirados y tamaño excesivo)
    [self cleanCache];
    // Guarda la cache al userdefaults
    [self saveCacheInfoToUserDefaults];
}

// Recupera los metadatos con la información de caché para una clave
//    Se encarga de desempaquetar de NSData a CacheInfo
- (CacheInfo *) getCachedInfoForKey:(id)key
{
    CacheInfo *cacheInfo = nil;
    NSData *dataCacheInfo = [self.dicCacheInfo objectForKey:key];
    if (dataCacheInfo){
        cacheInfo = [NSKeyedUnarchiver unarchiveObjectWithData:dataCacheInfo];
    }
    return cacheInfo;
}

- (void) deleteCacheForKey:(id)key
{
    // Borra la entrada de los metadatos
    [self.dicCacheInfo removeObjectForKey:key];
    // Lo borra de disco
    [self removeDataFromDiskForKey:key];
    // Limpia la cache (expirados y tamaño excesivo)
    [self cleanCache];
    // Guarda la cache al userdefaults
    [self saveCacheInfoToUserDefaults];
}

// Guarda el diccionario con los metadatos de la cache en el UserDefaults
- (void) saveCacheInfoToUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:self.dicCacheInfo forKey:KEY_USER_DEFAULTS_CACHE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSInteger) cacheSize
{
    NSInteger size = 0;
    for (NSString *key in [self.dicCacheInfo allKeys]) {
        CacheInfo *cacheInfo = [self getCachedInfoForKey:key];
        size += [cacheInfo.size intValue];
    }
    return size;
}

// Elimina de la cache el elemento que hace más tiempo que ha sido accedido
- (void) deleteLastAccessed
{
    NSString *keyForLastAccessed = nil;
    NSDate *dateLastAccessed = [NSDate date];
    for (NSString *key in [self.dicCacheInfo allKeys]) {
        CacheInfo *cacheInfo = [self getCachedInfoForKey:key];
        if ([dateLastAccessed timeIntervalSinceDate:cacheInfo.lastAccess] > 0){
            dateLastAccessed = cacheInfo.lastAccess;
            keyForLastAccessed = key;
        }
    }
    if (keyForLastAccessed){
        [self deleteCacheForKey:keyForLastAccessed];
    }
}

// ---------------------------------------
//  -- Getters/Setters
// ---------------------------------------
#pragma mark - Getters/Setters

- (NSString *)cacheDirectory
{
	if (!_cacheDirectory) {
        NSArray * cacheDirectoriesURLsArray = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        _cacheDirectory = [[cacheDirectoriesURLsArray lastObject] path];
	}
	return _cacheDirectory;
}

- (NSUInteger)maxCacheSize
{
	if (!_maxCacheSize){
        _maxCacheSize = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ?
            CACHE_MAX_SIZE * CACHE_MAX_SIZE_IPAD_FACTOR : CACHE_MAX_SIZE;
    }
	return _maxCacheSize;
}

- (void) setMaxCacheSize:(NSUInteger)maxCacheSize
{
    _maxCacheSize = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ?
        maxCacheSize * CACHE_MAX_SIZE_IPAD_FACTOR : maxCacheSize;
}

- (NSUInteger) maxCacheDuration
{
	if (!_maxCacheSize){
        _maxCacheSize = CACHE_EXPIRATION_SECONDS;
    }
	return _maxCacheSize;
}

- (NSMutableDictionary *) dicCacheInfo
{
    if (!_dicCacheInfo){
        // Obtiene el diccionario con los elementos del array del userdefaults
        _dicCacheInfo = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:KEY_USER_DEFAULTS_CACHE] mutableCopy];
        if (!_dicCacheInfo) {
            // No existía en el userDefaults, inicializa uno
            _dicCacheInfo = [[NSMutableDictionary alloc] init];
        }
    }
    return _dicCacheInfo;
}

- (NSFileManager *)fileManager
{
	if (!_fileManager){
        _fileManager = [[NSFileManager alloc] init];
    }
	return _fileManager;
}

@end
