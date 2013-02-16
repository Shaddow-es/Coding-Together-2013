//
//  CardChooserViewController.m
//  CardViewer
//
//  Created by David Muñoz Fernández on 16/02/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "CardChooserViewController.h"
#import "CardDisplayViewController.h"

@interface CardChooserViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *suitSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (nonatomic) NSUInteger rank;
@property (nonatomic, readonly) NSString *suit;

@end

@implementation CardChooserViewController

@synthesize rank = _rank;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowCard"]) {
        if ([segue.destinationViewController isKindOfClass:[CardDisplayViewController class]]) {
            CardDisplayViewController *cdvc = (CardDisplayViewController *) segue.destinationViewController;
            cdvc.rank = self.rank;
            cdvc.suit = self.suit;
            
            cdvc.title = [[self rankAsString] stringByAppendingString:self.suit];
        }
    }
}

- (NSUInteger)rank
{
    return (_rank) ? _rank : 1;
}


- (void) setRank:(NSUInteger)rank
{
    _rank = rank;
    self.rankLabel.text = [self rankAsString];
}

- (NSString *)suit{
    return [self.suitSegmentedControl titleForSegmentAtIndex:self.suitSegmentedControl.selectedSegmentIndex];
}

- (IBAction)changeRank:(UISlider *)sender {
    self.rank = round(sender.value);
}


// Devuelve el número como un String
- (NSString *) rankAsString
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

@end
