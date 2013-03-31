//
//  CTRTimerListViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-31.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerListViewController.h"
#import "CTRTimerDetailViewController.h"
#import "CTRTimerModel.h"

@interface CTRTimerListViewController ()

@property (nonatomic, strong) NSArray *coffeeTimers;
@property (nonatomic, strong) NSArray *teaTimers;

@end

@implementation CTRTimerListViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.coffeeTimers = @[[[CTRTimerModel alloc] initWithName:@"Columbian" duration:240],
                          [[CTRTimerModel alloc] initWithName:@"Mexican" duration:200]];
    self.teaTimers = @[[[CTRTimerModel alloc] initWithName:@"Green Tea" duration:400],
                       [[CTRTimerModel alloc] initWithName:@"Oolong" duration:300],
                       [[CTRTimerModel alloc] initWithName:@"Rooibos" duration:480]];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CTRTimerModel *model;
    
    if (indexPath.section == 0)
    {
        model = self.coffeeTimers[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        model = self.teaTimers[indexPath.row];
    }
    
    if ([segue.identifier isEqualToString:@"pushDetail"])
    {
        CTRTimerDetailViewController *viewController = segue.destinationViewController;
        viewController.timerModel = model;
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"editDetail"])
    {
        if (self.tableView.isEditing)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }

    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections, in our case, the number of arrays we're displaying
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        // The coffee timer section
        return self.coffeeTimers.count;
    }
    else if (section == 1)
    {
        // The tea timer section
        return self.teaTimers.count;
    }
    
    // This line is just to silence the compiler warning
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    CTRTimerModel *timerModel;
    // Configure the cell
    if (indexPath.section == 0)
    {
        // The coffee timer section
        timerModel = self.coffeeTimers[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        timerModel = self.teaTimers[indexPath.row];
    }
    
    cell.textLabel.text = timerModel.name;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        // The coffee timer section
        return @"Coffees";
    }
    else if (section == 1)
    {
        return @"Teas";
    }
    
    // Just to silence the compiler
    return @"";
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate



@end
