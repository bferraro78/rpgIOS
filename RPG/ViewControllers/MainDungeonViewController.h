//
//  MainDungeonViewController.h
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef MainDungeonViewController_h
#define MainDungeonViewController_h
#import <UIKit/UIKit.h>

#import "MainCharacter.h"
#import "Dungeon.h"
#import "Space.h"
#import "Party.h"
#import "CreateClassManager.h"

#import "HeroProfileViewController.h" // Main character profile
#import "EquipViewController.h" // Equipment
#import "InventoryViewController.h" // Inventory
#import "SkillViewController.h" // Skills

#import "SendDataMCManager.h"


@interface MainDungeonViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *MainTextField;
@property NSMutableString *mainText;

// DEBUGG
@property (strong, nonatomic) IBOutlet UIButton *CombatButton;

//@property Dungeon *currMap;

-(void)setUpTabBarView;

@end

#endif /* MainDungeonViewController_h */
