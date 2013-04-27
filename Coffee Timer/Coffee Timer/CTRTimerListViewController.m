//
//  CTRTimerListViewController.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-31.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRTimerListViewController.h"
#import "CTRTimerDetailViewController.h"
#import "CTRTimerEditViewController.h"
#import "CTRTimerModel.h"

enum {
    CTRTimerListCoffeeSection = 0,
    CTRTimerListTeaSection,
    CTRTimerListNumberOfSections
};

@interface CTRTimerListViewController ()

@property (nonatomic, strong) NSArray *coffeeTimers;
@property (nonatomic, strong) NSArray *teaTimers;

@end

@implementation CTRTimerListViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.coffeeTimers = @[[[CTRTimerModel alloc] initWithName:@"Columbian" duration:240 type:CTRTimerModelTypeCoffee],
                          [[CTRTimerModel alloc] initWithName:@"Mexican" duration:200 type:CTRTimerModelTypeCoffee]];
    self.teaTimers = @[[[CTRTimerModel alloc] initWithName:@"Green Tea" duration:400 type:CTRTimerModelTypeTea],
                       [[CTRTimerModel alloc] initWithName:@"Oolong" duration:300 type:CTRTimerModelTypeTea],
                       [[CTRTimerModel alloc] initWithName:@"Rooibos" duration:480 type:CTRTimerModelTypeTea]];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self presentedViewController] != nil)
    {
        [self.tableView reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *cell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        // Determine the model represented by the tapped cell.
        CTRTimerModel *model;
        if (indexPath.section == CTRTimerListCoffeeSection)
        {
            model = self.coffeeTimers[indexPath.row];
        }
        else if (indexPath.section == CTRTimerListTeaSection)
        {
            model = self.teaTimers[indexPath.row];
        }
        
        // Determine which segue is being prepared for
        if ([segue.identifier isEqualToString:@"pushDetail"])
        {
            CTRTimerDetailViewController *viewController = segue.destinationViewController;
            viewController.timerModel = model;
        }
        else if ([segue.identifier isEqualToString:@"editDetail"])
        {
            UINavigationController *navigationController = segue.destinationViewController;
            CTRTimerEditViewController *viewController = (CTRTimerEditViewController *)navigationController.topViewController;
            viewController.delegate = self;
            
            viewController.timerModel = model;
        }
    }
    else
    {
        if ([segue.identifier isEqualToString:@"newTimer"])
        {
            UINavigationController *navigationController = segue.destinationViewController;
            CTRTimerEditViewController *viewController = (CTRTimerEditViewController *)navigationController.topViewController;
            viewController.creatingNewTimer = YES;
            viewController.delegate = self;
            viewController.timerModel = [[CTRTimerModel alloc] initWithName:@"" duration:240 type:CTRTimerModelTypeCoffee];
        }
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"pushDetail"])
    {
        if (self.tableView.isEditing)
        {
            return NO;
        }
    }

    return YES;
}

#pragma mark - Private Methods

-(CTRTimerModel *)timerModelForIndexPath:(NSIndexPath *)indexPath
{
    CTRTimerModel *timerModel;
    if (indexPath.section == CTRTimerListCoffeeSection)
    {
        // The coffee timer section
        timerModel = self.coffeeTimers[indexPath.row];
    }
    else if (indexPath.section == CTRTimerListTeaSection)
    {
        timerModel = self.teaTimers[indexPath.row];
    }
    
    return timerModel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections, in our case, the number of arrays we're displaying
    return CTRTimerListNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == CTRTimerListCoffeeSection)
    {
        // The coffee timer section
        return self.coffeeTimers.count;
    }
    else if (section == CTRTimerListTeaSection)
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
    
    CTRTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    // Configure the cell
    cell.textLabel.text = timerModel.name;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == CTRTimerListCoffeeSection)
    {
        // The coffee timer section
        return @"Coffees";
    }
    else if (section == CTRTimerListTeaSection)
    {
        return @"Teas";
    }
    
    // Just to silence the compiler
    return @"";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        if (indexPath.section == CTRTimerListCoffeeSection)
        {
            NSMutableArray *mutableArray = [self.coffeeTimers mutableCopy];
            [mutableArray removeObjectAtIndex:indexPath.row];
            self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
        }
        else if (indexPath.section == CTRTimerListTeaSection)
        {
            NSMutableArray *mutableArray = [self.teaTimers mutableCopy];
            [mutableArray removeObjectAtIndex:indexPath.row];
            self.teaTimers = [NSArray arrayWithArray:mutableArray];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSMutableArray *mutableArray;
    if (sourceIndexPath.section == CTRTimerListCoffeeSection)
    {
        mutableArray = [self.coffeeTimers mutableCopy];
    }
    else if (sourceIndexPath.section == CTRTimerListTeaSection)
    {
        mutableArray = [self.teaTimers mutableCopy];
    }
    
    CTRTimerModel *model = mutableArray[sourceIndexPath.row];
    [mutableArray removeObjectAtIndex:sourceIndexPath.row];
    [mutableArray insertObject:model atIndex:destinationIndexPath.row];
    
    if (sourceIndexPath.section == CTRTimerListCoffeeSection)
    {
        self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
    }
    else if (sourceIndexPath.section == CTRTimerListTeaSection)
    {
        self.teaTimers = [NSArray arrayWithArray:mutableArray];
    }
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing)
    {
        [self performSegueWithIdentifier:@"editDetail" sender:[self.tableView cellForRowAtIndexPath:indexPath]];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([NSStringFromSelector(action) isEqualToString:@"copy:"])
    {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    CTRTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
    
    UIPasteboard *sharedPasteboard = [UIPasteboard generalPasteboard];
    [sharedPasteboard setString:timerModel.name];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    // If the source and destination index paths are the same,
    // then return the proposed index path
    if (sourceIndexPath.section == proposedDestinationIndexPath.section)
    {
        return proposedDestinationIndexPath;
    }
    
    // The sections are different, which we want to disallow.
    
    if (sourceIndexPath.section == CTRTimerListCoffeeSection)
    {
        // This is coming from the coffee section, so return
        // the last index path in that section.
        
        return [NSIndexPath indexPathForRow:self.coffeeTimers.count - 1 inSection:CTRTimerListCoffeeSection];
    }
    else if (sourceIndexPath.section == CTRTimerListTeaSection)
    {
        // This is coming from the tea section, so return
        // the first index path in that section.
        return [NSIndexPath indexPathForRow:0 inSection:CTRTimerListTeaSection];
    }
    
    // Just to silence the compiler
    return sourceIndexPath;
}

#pragma mark - CTRTimerEditViewControllerDelegateMethods

-(void)timerEditViewControllerDidSaveTimerModel:(CTRTimerEditViewController *)viewController
{
    CTRTimerModelType type = viewController.timerModel.type;
    
    if (type == CTRTimerModelTypeCoffee)
    {
        if (![self.coffeeTimers containsObject:viewController.timerModel])
        {
            self.coffeeTimers = [self.coffeeTimers arrayByAddingObject:viewController.timerModel];
        }
        
        if ([self.teaTimers containsObject:viewController.timerModel])
        {
            NSMutableArray *mutableArray = [self.teaTimers mutableCopy];
            [mutableArray removeObject:viewController.timerModel];
            self.teaTimers = [NSArray arrayWithArray:mutableArray];
        }
    }
    else if (type == CTRTimerModelTypeTea)
    {
        if (![self.teaTimers containsObject:viewController.timerModel])
        {
            self.teaTimers = [self.teaTimers arrayByAddingObject:viewController.timerModel];
        }
        
        
        if ([self.coffeeTimers containsObject:viewController.timerModel])
        {
            NSMutableArray *mutableArray = [self.coffeeTimers mutableCopy];
            [mutableArray removeObject:viewController.timerModel];
            self.coffeeTimers = [NSArray arrayWithArray:mutableArray];
        }
    }
}

-(void)timerEditViewControllerDidCancel:(CTRTimerEditViewController *)viewController
{
    // Nothing to do for now
}

@end
