//
//  CTRTimerDetailViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-23.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerDetailViewController.h"
#import "CTRTimerEditViewController.h"

@interface CTRTimerDetailViewController ()

@property (nonatomic, weak) IBOutlet UILabel *countdownLabel;
@property (nonatomic, weak) IBOutlet UIButton *startStopButton;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeRemaining;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation CTRTimerDetailViewController

#pragma mark - View Controller Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.timerModel.name;
    self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                               self.timerModel.duration / 60,
                               self.timerModel.duration % 60];
    
    [self.timerModel addObserver:self
                      forKeyPath:@"duration"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    [self.timerModel addObserver:self
                      forKeyPath:@"name"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
}

-(void)dealloc
{
    [self.timerModel removeObserver:self forKeyPath:@"duration"];
    [self.timerModel removeObserver:self forKeyPath:@"name"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editDetail"])
    {
        UINavigationController *navigationController = segue.destinationViewController;
        CTRTimerEditViewController *viewController = (CTRTimerEditViewController *)navigationController.topViewController;
        viewController.timerModel = self.timerModel;
    }
}

#pragma mark - User Interaction Methods

-(IBAction)buttonPressed:(id)sender
{
    if (self.timer)
    {
        // Timer is running and button is pressed. Stop timer.
        
        [self.navigationItem setHidesBackButton:NO animated:YES];
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        [self.startStopButton setTitle:NSLocalizedString(@"Start", @"Start button text") forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [self.timer invalidate];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    }
    else
    {
        // Timer is not running and button is pressed. Start timer.
        
        [self.navigationItem setHidesBackButton:YES animated:YES];
        [self.startStopButton setTitle:NSLocalizedString(@"Stop", @"Stop button text") forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
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
            [self notifyUser:NSLocalizedString(@"Coffee Timer stopped running.", @"Application was terminated in background notification text")];
        }];
    }
}

#pragma mark - Private Methods

-(void)notifyUser:(NSString *)alert
{
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Coffee Timer", @"User notification title text")
                                    message:alert
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:NSLocalizedString(@"OK", @"User notification alert button text"), nil] show];
    }
    else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = alert;
        notification.alertAction = NSLocalizedString(@"OK", "User local notification OK button text");
        notification.fireDate = nil;
        notification.soundName = UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - NSTimer Methods

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
        self.countdownLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                    self.timerModel.duration / 60,
                                    self.timerModel.duration % 60];
        [self.timer invalidate];
        [self.startStopButton setTitle:NSLocalizedString(@"Start", @"Start button text") forState:UIControlStateNormal];
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
        [self notifyUser:NSLocalizedString(@"Coffee Timer Completed!", @"Coffee timer completed alert message")];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

#pragma mark - KVO methods

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if ([keyPath isEqualToString:@"duration"])
    {
        if (!self.timer)
        {
            self.countdownLabel.text = [NSString stringWithFormat:@"%d:%d",
                                       self.timerModel.duration / 60,
                                       self.timerModel.duration % 60];
        }
    }
    else if ([keyPath isEqualToString:@"name"])
    {
        self.title = self.timerModel.name;
    }
}

@end
