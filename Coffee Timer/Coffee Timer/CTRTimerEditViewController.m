//
//  CTRTimerEditViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerEditViewController.h"

@interface CTRTimerEditViewController ()

@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UILabel *minutesLabel;
@property (nonatomic, weak) IBOutlet UILabel *secondsLabel;
@property (nonatomic, weak) IBOutlet UISlider *minutesSlider;
@property (nonatomic, weak) IBOutlet UISlider *secondsSlider;
@property (nonatomic, weak) IBOutlet UISegmentedControl *timerTypeSegmentedControl;

@end

@implementation CTRTimerEditViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger numberOfMinutes = self.timerModel.duration / 60;
    NSInteger numberOfSeconds = self.timerModel.duration % 60;
    
    self.nameField.text = self.timerModel.name;
    [self updateLabelsWithMinutes:numberOfMinutes seconds:numberOfSeconds];
    self.minutesSlider.value = numberOfMinutes;
    self.secondsSlider.value = numberOfSeconds;
    
    if (self.timerModel.type == CTRTimerModelTypeCoffee)
    {
        self.timerTypeSegmentedControl.selectedSegmentIndex = 0;
    }
    else
    {
        self.timerTypeSegmentedControl.selectedSegmentIndex = 1;
    }
    
    [self.timerTypeSegmentedControl
     setTitle:NSLocalizedString(@"Coffee", @"Segmented control coffee title")
     forSegmentAtIndex:0];
    [self.timerTypeSegmentedControl
     setTitle:NSLocalizedString(@"Tea", @"Segmented control tea title")
     forSegmentAtIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

-(void)saveModel
{
    CTRTimerModelType type;
    
    if (self.timerTypeSegmentedControl.selectedSegmentIndex == 0)
    {
        type = CTRTimerModelTypeCoffee;
    }
    else
    {
        type = CTRTimerModelTypeTea;
    }
    
    self.timerModel.name = self.nameField.text;
    self.timerModel.duration = (NSInteger)self.minutesSlider.value * 60 + (NSInteger)self.secondsSlider.value;
    self.timerModel.type = type;
}

-(void)updateLabelsWithMinutes:(NSInteger)numberOfMinutes seconds:(NSInteger)numberOfSeconds
{
    if (numberOfMinutes == 1)
    {
        self.minutesLabel.text = NSLocalizedString(@"1 Minute", @"1 Minute singular text");
    }
    else
    {
        self.minutesLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Minutes", @"Minute plural text"), numberOfMinutes];
    }
    
    if (numberOfSeconds == 1)
    {
        self.secondsLabel.text = NSLocalizedString(@"1 Second", @"Seconds singular text");
    }
    else
    {
        self.secondsLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d Seconds", @"Seconds plural text"), numberOfSeconds];
    }
}

#pragma mark - User Interaction

-(IBAction)cancelButtonWasPressed:(id)sender
{
    [self.delegate timerEditViewControllerDidCancel:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)doneButtonWasPressed:(id)sender
{
    [self saveModel];
    
    [self.delegate timerEditViewControllerDidSaveTimerModel:self];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)sliderValueChanged:(id)sender
{
    NSInteger numberOfMinutes = (NSInteger)self.minutesSlider.value;
    NSInteger numberOfSeconds = (NSInteger)self.secondsSlider.value;
    
    [self updateLabelsWithMinutes:numberOfMinutes seconds:numberOfSeconds];
}

@end
