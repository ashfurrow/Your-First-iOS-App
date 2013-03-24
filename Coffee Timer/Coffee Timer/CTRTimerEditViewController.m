//
//  CTRTimerEditViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerEditViewController.h"

@interface CTRTimerEditViewController ()

@end

@implementation CTRTimerEditViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numberOfMinutes = self.timerModel.duration / 60;
    NSInteger numberOfSeconds = self.timerModel.duration % 60;
    
    self.nameField.text = self.timerModel.coffeeName;
    [self updateLabelsWithMinutes:numberOfMinutes seconds:numberOfSeconds];
    self.minutesSlider.value = numberOfMinutes;
    self.secondsSlider.value = numberOfSeconds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)saveModel
{
    self.timerModel.coffeeName = self.nameField.text;
    self.timerModel.duration = (NSInteger)self.minutesSlider.value * 60 + (NSInteger)self.secondsSlider.value;
}

-(void)updateLabelsWithMinutes:(NSInteger)numberOfMinutes seconds:(NSInteger)numberOfSeconds
{
    if (numberOfMinutes == 1)
    {
        self.minutesLabel.text = @"1 Minute";
    }
    else
    {
        self.minutesLabel.text = [NSString stringWithFormat:@"%d Minutes", numberOfMinutes];
    }
    
    if (numberOfSeconds == 1)
    {
        self.secondsLabel.text = @"1 Second";
    }
    else
    {
        self.secondsLabel.text = [NSString stringWithFormat:@"%d Seconds", numberOfSeconds];
    }
}

#pragma mark - User Interaction

-(IBAction)cancelButtonWasPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonWasPressed:(id)sender
{
    [self saveModel];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sliderValueChanged:(id)sender
{
    NSInteger numberOfMinutes = (NSInteger)self.minutesSlider.value;
    NSInteger numberOfSeconds = (NSInteger)self.secondsSlider.value;
    
    [self updateLabelsWithMinutes:numberOfMinutes seconds:numberOfSeconds];
}

@end
