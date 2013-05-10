//
//  CTRTimerEditViewController.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-24.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRTimerModel.h"

@class CTRTimerEditViewController;

@protocol CTRTimerEditViewControllerDelegate <NSObject>

-(void)timerEditViewControllerDidCancel:(CTRTimerEditViewController *)viewController;
-(void)timerEditViewControllerDidSaveTimerModel:(CTRTimerEditViewController *)viewController;

@end

@interface CTRTimerEditViewController : UIViewController

@property (nonatomic, strong) CTRTimerModel *timerModel;
@property (nonatomic, assign) BOOL creatingNewTimer;
@property (nonatomic, weak) id <CTRTimerEditViewControllerDelegate> delegate;

@end
