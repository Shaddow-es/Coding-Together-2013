//
//  GameResultViewController.m
//  Matchismo
//
//  Created by David Muñoz Fernández on 09/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@end

@implementation GameResultViewController

- (void)updateUI
{
    NSString *displayText = @"";
    
    for (GameResult *result in [GameResult allGameResults]) {
        displayText  = [displayText stringByAppendingFormat:@"Puntuación: %d (%@, %g0s)\n", result.score, result.end, round(result.duration)];
    }
    self.display.text = displayText;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
