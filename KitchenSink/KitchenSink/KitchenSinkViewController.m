//
//  KitchenSinkViewController.m
//  KitchenSink
//
//  Created by David Muñoz Fernández on 10/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "KitchenSinkViewController.h"
#import "AskerViewController.h"

@interface KitchenSinkViewController ()

@end

@implementation KitchenSinkViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Ask"]) {
        AskerViewController *asker = segue.destinationViewController;
        asker.question = @"¿Qué comida quieres en la cesta?";
    }
}

- (IBAction) cancelAsking:(UIStoryboardSegue *)segue
{
}

- (IBAction) doneAsking:(UIStoryboardSegue *)segue
{
    AskerViewController *asker = segue.sourceViewController;
    NSLog(@"%@", asker.answer);
}

@end
