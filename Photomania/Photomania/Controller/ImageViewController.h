//
//  ImageViewController.h
//  Shutterbug
//
//  Created by David Muñoz Fernández on 01/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

// Cada vez que se actualiza la URL carga la imamgen en un ScrollView
@property (nonatomic, strong) NSURL *imageURL;

@end
