//
//  SettingsViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 12/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "SettingsViewController.h"
#import "GameResult.h"
#import "GameSettings.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *flipAnimatedSwitch;

@end

@implementation SettingsViewController


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller
- (IBAction)changeFlipAnimation:(UISwitch *)sender {
    [[[GameSettings alloc] init] setFlipAnimated:sender.isOn];
}

- (IBAction)resetGameResult {
    [GameResult resetAllGameResults];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Cargar las opciones del objeto GameSettings
    self.flipAnimatedSwitch.on = [[[GameSettings alloc] init] isFlipAnimated];
    
    // Load background image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-background"]];
}

@end
