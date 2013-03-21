//
//  CTRViewController.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTRViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet UISlider *slider;
@property (nonatomic, strong) IBOutlet UIProgressView *progressView;

-(IBAction)buttonWasPressed:(id)sender;
-(IBAction)sliderValueChanged:(id)sender;

@end
