//
//  AppDelegate.h
//  RPG
//
//  Created by Ben Ferraro on 5/13/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "MCManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) MCManager *mcManager; // MCManager object

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic, strong) ViewController *root;

@end

