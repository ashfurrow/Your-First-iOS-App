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

@end

@implementation CTRTimerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.timerModel.name;
    self.durationLabel.text = [NSString stringWithFormat:@"%d min %d sec",
                               self.timerModel.duration / 60,
                               self.timerModel.duration % 60];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
