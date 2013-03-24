//
//  CTRViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRViewController.h"
#import "CTRTimerDetailViewController.h"
#import "CTRTimerEditViewController.h"

@interface CTRViewController ()

@end

@implementation CTRViewController

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"View is loaded.");
    
    self.title = @"Root";
    
    [self setupModel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Preparing for segue with identifier:%@", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"pushDetail"])
    {
        CTRTimerDetailViewController *viewController = segue.destinationViewController;
        viewController.timerModel = self.timerModel;
    }
    else if ([segue.identifier isEqualToString:@"editDetail"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        CTRTimerEditViewController *viewController = (CTRTimerEditViewController *)(navigationController.topViewController);
        viewController.timerModel = self.timerModel;
    }
}

#pragma mark - Private Methods

-(void)setupModel
{
    self.timerModel = [[CTRTimerModel alloc] initWithCoffeeName:@"Columbian Coffee" duration:240];
}

-(void)updateUserInterface
{
    self.label.text = self.timerModel.coffeeName;
}

#pragma mark - Overridden Properties

-(void)setTimerModel:(CTRTimerModel *)timerModel
{
    _timerModel = timerModel;
    
    [self updateUserInterface];
}

#pragma mark - Interaction Methods

-(IBAction)buttonWasPressed:(id)sender
{
    NSLog(@"Button was pressed.");
    
    // Get the current date and time.
    NSDate *date = [NSDate date];
    
    // Update the label.
    self.label.text = [NSString stringWithFormat:@"Button pressed at %@", date];
}

@end
