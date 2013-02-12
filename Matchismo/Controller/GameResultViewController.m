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
@property (strong, nonatomic) NSArray *allGameResults;
@end

@implementation GameResultViewController


// ---------------------------------------
//  -- Actions
// ---------------------------------------
#pragma mark - Actions

- (IBAction)changeSortMode:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(dateCompare:)];
            break;
        case 1:
            self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(scoreCompare:)];
            break;
        case 2:
            self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(durationCompare:)];
            break;
        default:
            break;
    }
    self.allGameResults = [[self.allGameResults reverseObjectEnumerator] allObjects];
    [self updateUI];
}

// ---------------------------------------
//  -- Private methods
// ---------------------------------------
#pragma mark - Private Methods

- (void)updateUI
{
    NSMutableAttributedString *displayText = [[NSMutableAttributedString alloc] init];
    
    for (GameResult *result in self.allGameResults) {
        NSString *dateFormated = [NSDateFormatter localizedStringFromDate:result.end
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterShortStyle];
        NSString *extraInfo = [NSString stringWithFormat:@"(%@, %g0s)\n", dateFormated, round(result.duration)];
        NSString *puntos = [NSString stringWithFormat:@"Puntos: %3d ", result.score];
        
        NSAttributedString *puntosAttributedString = [[NSAttributedString alloc] initWithString:puntos
                                                                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}];
        NSAttributedString *extraInfoAttributedString = [[NSAttributedString alloc] initWithString:extraInfo
                                                                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [displayText appendAttributedString:puntosAttributedString];
        [displayText appendAttributedString:extraInfoAttributedString];
    }
    [self.display setAttributedText:displayText];
}


// ---------------------------------------
//  -- Controller
// ---------------------------------------
#pragma mark - Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load background image
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"table-background"]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.allGameResults = [GameResult allGameResults];
    self.allGameResults = [self.allGameResults sortedArrayUsingSelector:@selector(dateCompare:)];
    self.allGameResults = [[self.allGameResults reverseObjectEnumerator] allObjects];
    [self updateUI];
}

@end
