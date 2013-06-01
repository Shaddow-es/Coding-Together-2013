//
//  RecentPhotoViewController.m
//  SPoT
//
//  Created by David Muñoz Fernández on 19/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "RecentPhotoViewController.h"
#import "RecentPhotos.h"

@interface RecentPhotoViewController ()

@end

@implementation RecentPhotoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.photos = [RecentPhotos photos];
    [self.tableView reloadData];
}
                   
@end
