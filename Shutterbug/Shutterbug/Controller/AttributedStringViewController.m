//
//  AttributedStringViewController.m
//  Shutterbug
//
//  Created by David Muñoz Fernández on 02/05/13.
//  Copyright (c) 2013 David Muñoz Fernández. All rights reserved.
//

#import "AttributedStringViewController.h"

@interface AttributedStringViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation AttributedStringViewController


// ---------------------------------------
//  -- Getters & Setters
// ---------------------------------------
#pragma mark - Getters & Setters

- (void) setText:(NSAttributedString *)text
{
    _text = text;
    self.textView.attributedText = text;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.textView.attributedText = self.text;
}

@end
