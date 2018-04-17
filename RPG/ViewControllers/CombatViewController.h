//
//  CombatViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/24/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCharacter.h"
#import "Party.h"
#import "Enemy.h"
#import "EnemyParty.h"
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

@property NSAttributedString *combatTextTmpString; // represents the text at the moment, constantly reset
@property NSMutableAttributedString *combatSetText; // represents the extend text of the whole fight, updated every change in combat text
@property (strong, nonatomic) IBOutlet UITextView *CombatText; // actual text view


// Party of enimies
@property(nonatomic) EnemyParty *EnemyParty;


/* HEROS MOVE */
@property (strong, nonatomic) NSString *heroMoveName;
@property BOOL critHit;

@property (strong, nonatomic) UITextView *moveView; // Pop up box Long Press


-(void)initCombat;
-(void)heroManageBuffs:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;
-(int)heroDamageReduction:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage Enemy:(Enemy*)e;
-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage;
-(void)critChance:(int)extraChance;


@end
