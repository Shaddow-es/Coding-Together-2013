//
//  SetCardHelper.h
//  Matchismo
//
//  Created by David Muñoz Fernández on 24/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#ifndef Matchismo_SetCardHelper_h
#define Matchismo_SetCardHelper_h


// -----------------------------------------------
//  -- Enumerados para las propiedades de SetCard
// -----------------------------------------------

typedef NS_ENUM(NSInteger, SetCardColorType) {
    SetCardColorTypeRed,
    SetCardColorTypeGreen,
    SetCardColorTypePurple
};

typedef NS_ENUM(NSInteger, SetCardShadeType) {
    SetCardShadeTypeSolid,
    SetCardShadeTypeStriped,
    SetCardShadeTypeOpen
};

typedef NS_ENUM(NSInteger, SetCardSymbolType) {
    SetCardSymbolTypeDiamond,
    SetCardSymbolTypeSquiggle,
    SetCardSymbolTypeOval
};

#endif
