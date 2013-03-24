//
//  CTRTimerEditViewController.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRTimerModel.h"

@interface CTRTimerEditViewController : UIViewController

@property (nonatomic, strong) CTRTimerModel *timerModel;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) IBOutlet UILabel *minutesLabel;
@property (nonatomic, strong) IBOutlet UILabel *secondsLabel;
@property (nonatomic, strong) IBOutlet UISlider *minutesSlider;
@property (nonatomic, strong) IBOutlet UISlider *secondsSlider;

-(IBAction)cancelButtonWasPressed:(id)sender;
-(IBAction)doneButtonWasPressed:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
