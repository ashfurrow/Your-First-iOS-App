//
//  CTRTimerDetailViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-23.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerDetailViewController.h"

@interface CTRTimerDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *durationLabel;
@property (nonatomic, strong) IBOutlet UILabel *countdownLabel;
@property (nonatomic, strong) IBOutlet UIButton *startStopButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeRemaining;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation CTRTimerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.timerModel.name;
    self.durationLabel.text = [NSString stringWithFormat:@"%d min %d sec",
                               self.timerModel.duration / 60,
                               self.timerModel.duration % 60];
    self.countdownLabel.text = @"Timer not started.";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonPressed:(id)sender
{
    if (self.timer)
    {
        // Timer is running and button is pressed. Stop timer.
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.countdownLabel.text = @"Timer stopped.";
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    }
    else
    {
        // Timer is not running and button is pressed. Start timer.
        
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.timeRemaining = self.timerModel.duration;
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timeRemaining / 60,
                                    self.timeRemaining % 60];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [self notifyUser:@"Coffee Timer stopped running."];
        }];
    }
}

-(void)notifyUser:(NSString *)alert
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [[[UIAlertView alloc] initWithTitle:@"Coffee Timer"
                                    message:alert
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
    }
    else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = alert;
        notification.alertAction = @"OK";
        notification.fireDate = nil;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

-(void)timerFired:(NSTimer *)timer
{
    self.timeRemaining -= 1;
    if (self.timeRemaining > 0)
    {
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timeRemaining / 60,
                                    self.timeRemaining % 60];
    }
    else
    {
        self.countdownLabel.text = @"Timer completed.";
        [self.timer invalidate];
        self.timer = nil;
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
        [self notifyUser:@"Coffee Timer Completed!"];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

@end
