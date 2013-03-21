//
//  CTRViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRViewController.h"

@interface CTRViewController ()

@end

@implementation CTRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View is loaded.");
    
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonWasPressed:(id)sender
{
    NSLog(@"Button was pressed.");
    
    // Get the current date and time.
    NSDate *date = [NSDate date];
    
    // Update the label.
    self.label.text = [NSString stringWithFormat:@"Button pressed at %@", date];
}

-(IBAction)sliderValueChanged:(id)sender
{
    NSLog(@"Slider value changed to %f", self.slider.value);
    
    // Update our progressView's progress to match
    // the slider's value.
    self.progressView.progress = self.slider.value;
}

@end
