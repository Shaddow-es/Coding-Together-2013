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
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegmentedControl;

@end

@implementation SettingsViewController

// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

- (IBAction)changeFlipAnimation:(UISwitch *)sender
{
    [GameSettings setFlipAnimated:sender.isOn];
}

- (IBAction)resetGameResult
{
    [GameResult resetAllGameResults];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
    [GameSettings setMatchismoMatchCount:sender.selectedSegmentIndex + 2];
}

// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Cargar las opciones del objeto GameSettings
    self.flipAnimatedSwitch.on = [GameSettings isFlipAnimated];
    self.matchModeSegmentedControl.selectedSegmentIndex = [GameSettings matchismoMatchCount]-2;
    
    // Load background image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-background"]];
}

@end
