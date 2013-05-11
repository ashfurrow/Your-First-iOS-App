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

#import "CTRAppDelegate.h"

enum {
    CTRTimerListCoffeeSection = 0,
    CTRTimerListTeaSection,
    CTRTimerListNumberOfSections
};

@interface CTRTimerListViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL userReorderingCells;

@end

@implementation CTRTimerListViewController

#pragma mark - UIViewController Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSError *fetchError;
    if (![self.fetchedResultsController performFetch:&fetchError])
    {
        NSLog(@"Error fetching: %@", fetchError);
    }
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
        CTRTimerModel *model = [self timerModelForIndexPath:indexPath];
        
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
            NSManagedObjectContext *managedObjectContext = [(CTRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
            CTRTimerModel *model = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"CTRTimerModel"
                                    inManagedObjectContext:managedObjectContext];
            
            UINavigationController *navigationController = segue.destinationViewController;
            CTRTimerEditViewController *viewController = (CTRTimerEditViewController *)navigationController.topViewController;
            viewController.creatingNewTimer = YES;
            viewController.delegate = self;
            viewController.timerModel = model;
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
    CTRTimerModel *timerModel = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    return timerModel;
}

#pragma mark - Overridden properties

-(NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"CTRTimerModel"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"type" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
        NSManagedObjectContext *managedObjectContext = [(CTRAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:@"type" cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    
    return _fetchedResultsController;
}

#pragma mark - NSFetchedResultsControllerDelegate Methods

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id) anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.userReorderingCells) return;
    
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (self.userReorderingCells) return;
    
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.userReorderingCells) return;
    
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections, in our case, the number of arrays we're displaying
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    
    return sectionInfo.numberOfObjects;
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
        
        CTRTimerModel *timerModel = [self timerModelForIndexPath:indexPath];
        [timerModel.managedObjectContext deleteObject:timerModel];
    }
}

 - (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toIndexPath:(NSIndexPath *)destinationIndexPath
{
    self.userReorderingCells = YES;
    
    NSMutableArray *sectionObjects = [[[self.fetchedResultsController sections][sourceIndexPath.section] objects] mutableCopy];
    
    // Grab the item we're moving.
    NSManagedObject *movedObject = [[self fetchedResultsController] objectAtIndexPath:sourceIndexPath];
    
    // Remove the object we're moving from the array.
    [sectionObjects removeObject:movedObject];
    // Now re-insert it at the destination.
    [sectionObjects insertObject:movedObject atIndex:destinationIndexPath.row];
    
    // All of the objects are now in their correct order. Update each
    // object's displayOrder field by iterating through the array.
    for (NSInteger i = 0; i < sectionObjects.count; i++)
    {
        CTRTimerModel *model = sectionObjects[i];
        model.displayOrder = i;
    }
    
    [movedObject.managedObjectContext save:nil];
    
    self.userReorderingCells = NO;
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
        
        NSInteger numberOfCells = [self.fetchedResultsController.sections[CTRTimerListCoffeeSection] numberOfObjects];
        return [NSIndexPath indexPathForRow:numberOfCells - 1 inSection:CTRTimerListCoffeeSection];
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
    [viewController.timerModel.managedObjectContext save:nil];
}

-(void)timerEditViewControllerDidCancel:(CTRTimerEditViewController *)viewController
{
    if (viewController.creatingNewTimer)
    {
        [viewController.timerModel.managedObjectContext deleteObject:viewController.timerModel];
    }
}

@end
