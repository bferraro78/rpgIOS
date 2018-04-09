//
//  CombatViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/24/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCharacter.h"
#import "Enemy.h"
#import "EnemyDictionary.h"
#import "SkillDictionary.h"
#import "ItemDictionary.h"
#import "BuffDictionary.h"
#import "HealthBar.h"
#import "ResourceBar.h"
#import "LootManager.h"
#import "InventoryManager.h"
#import "Constants.h"

@interface CombatViewController : UIViewController

@property int turnNumber;

/* Hero Spec */
@property BOOL lightningSpecAdditionalTurn;

@property NSMutableDictionary *heroElementMap;
@property NSMutableDictionary *enemyElementMap;

// Timer
@property NSUInteger critTimerCount;
@property NSTimer *timer;
@property BOOL critHit;

@property NSAttributedString *combatTextTmpString; // represents the text at the moment, constantly reset
@property NSMutableAttributedString *combatSetText; // represents the extend text of the whole fight, updated every change in combat text
@property (strong, nonatomic) IBOutlet UITextView *CombatText; // actual text view
@property (strong, nonatomic) IBOutlet UITextView *HeroBuffsDebuffs;
@property (strong, nonatomic) IBOutlet UITextView *EnemyBuffsDebuffs;

@property(nonatomic) Enemy *e;

/* Skill Buttons */
@property (strong, nonatomic) IBOutlet UIButton *SkillOne;
@property (strong, nonatomic) IBOutlet UIButton *SkillTwo;
@property (strong, nonatomic) IBOutlet UIButton *SkillThree;
@property (strong, nonatomic) IBOutlet UIButton *SkillFour;

@property (strong, nonatomic) IBOutlet UIButton *critButton;


/* HEROS MOVE */
@property (strong, nonatomic) NSString *heroMoveName;

@property (strong, nonatomic) IBOutlet UILabel *EnemyLabel;
@property (strong, nonatomic) UITextView *moveView; // Pop up box Long Press

/* Health/Resource Bars */
@property (strong, nonatomic) IBOutlet HealthBar *heroHealthBar;
@property (strong, nonatomic) IBOutlet ResourceBar *heroResourceBar;
@property (strong, nonatomic) IBOutlet HealthBar *enemyHealthBar;


-(void)initCombat;
-(void)heroManageBuffs:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;
-(int)heroDamageReduction:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage Enemy:(Enemy*)e;
-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage;
-(void)critChance:(int)extraChance;


@end
