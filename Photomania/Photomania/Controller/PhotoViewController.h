//
//  PhotoViewController.h
//  Photomania
//
//  Created by David Muñoz Fernández on 10/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "ImageViewController.h"
#import "Photo.h"

@interface PhotoViewController : ImageViewController

@property (nonatomic, strong) Photo *photo;

@end
