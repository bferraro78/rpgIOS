//
//  ViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/13/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barbarian.h"
#import "Dungeon.h"
#import "Hero.h"
#import "Barbarian.h"
#import "Wizard.h"
#import "Rogue.h"
#import "Dungeon.h"
#import "Space.h"
#import "WeaponDictionary.h"
#import "ArmorDictionary.h"

#import "CombatViewController.h"
#import "InventoryViewController.h"
#import "EquipViewController.h"
#import "SkillViewController.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *printHero;
@property (strong, nonatomic) IBOutlet UITextView *MainTextField;
@property (strong, nonatomic) IBOutlet UITextView *MapTextField;
@property (strong, nonatomic) IBOutlet UIButton *HeroStats;
@property (strong, nonatomic) IBOutlet UIView *up;
@property (strong, nonatomic) IBOutlet UIView *down;
@property (strong, nonatomic) IBOutlet UIView *left;
@property (strong, nonatomic) IBOutlet UIView *right;
@property (strong, nonatomic) IBOutlet UIButton *inventory;
@property (strong, nonatomic) IBOutlet UIButton *SkillButton;

@property NSMutableString *mainText;

@property Hero *mainCharacter;
@property Dungeon *currMap;


@end

