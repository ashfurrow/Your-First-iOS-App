//
//  CTRViewController.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTRTimerModel.h"

@interface CTRViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *label;

@property (nonatomic, strong) CTRTimerModel *timerModel;

-(IBAction)buttonWasPressed:(id)sender;

@end
