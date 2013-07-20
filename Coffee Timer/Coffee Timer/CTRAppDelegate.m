//
//  CTRAppDelegate.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRAppDelegate.h"
#import "CTRTimerModel.h"

@implementation CTRAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application has launched.");
    
    BOOL hasLoadedDefaultModels = [[NSUserDefaults standardUserDefaults]
                                   boolForKey:@"loadedDefaults"];
    
    if (!hasLoadedDefaultModels)
    {
        for (NSInteger i = 0; i < 5; i++)
        {
            CTRTimerModel *model = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"CTRTimerModel"
                                    inManagedObjectContext:self.managedObjectContext];
            
            model.displayOrder = i;
            switch (i) {
                case 0:
                    model.name =
                        NSLocalizedString(@"Colombian", @"Default Colombian coffee name");
                    model.duration = 240;
                    model.type = CTRTimerModelTypeCoffee;
                    break;
                case 1:
                    model.name =
                        NSLocalizedString(@"Mexican", @"Default Mexican coffee name");
                    model.duration = 200;
                    model.type = CTRTimerModelTypeCoffee;
                    break;
                case 2:
                    model.name =
                        NSLocalizedString(@"Green Tea", @"Default green tea name");
                    model.duration = 400;
                    model.type = CTRTimerModelTypeTea;
                    break;
                case 3:
                    model.name =
                        NSLocalizedString(@"Oolong", @"Default oolong tea name");
                    model.duration = 300;
                    model.type = CTRTimerModelTypeTea;
                    break;
                case 4:
                    model.name =
                        NSLocalizedString(@"Rooibos", @"Default rooibos tea name");
                    model.duration = 480;
                    model.type = CTRTimerModelTypeTea;
                    break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:@"loadedDefaults"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Could not save managed object context: %@", error);
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application has resigned active.");
    
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Could not save managed object context: %@", error);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application has entered background.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Application has entered foreground.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data Stack

-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return _managedObjectContext;
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel:self.managedObjectModel];
        
        NSURL *applicationDocumentsDirectory =
        [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                inDomains:NSUserDomainMask] lastObject];
        
        NSURL *storeURL = [applicationDocumentsDirectory
                           URLByAppendingPathComponent:@"CoffeeTimer.sqlite"];
        
        NSError *error = nil;
        if (![_persistentStoreCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
              configuration:nil
              URL:storeURL
              options:nil
              error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return _persistentStoreCoordinator;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoffeeTimer" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

@end
