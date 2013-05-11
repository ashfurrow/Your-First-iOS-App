//
//  CTRTimerListViewController.h
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-31.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTRTimerEditViewController.h"

@interface CTRTimerListViewController : UITableViewController <CTRTimerEditViewControllerDelegate, NSFetchedResultsControllerDelegate>

@end
