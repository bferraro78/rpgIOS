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

#import "HeroPartyMemberView.h"
#import "EnemyPartyMemberView.h"

#import "EnemyDictionary.h"
#import "SkillDictionary.h"
#import "ItemDictionary.h"
#import "BuffDictionary.h"

#import "LootManager.h"
#import "CombatManager.h"
#import "InventoryManager.h"
#import "SendDataMCManager.h"

#import "CombatQueue.h"
#import "Constants.h"

@interface CombatViewController : UIViewController


/* Hero Spec */
@property BOOL lightningSpecAdditionalTurn;

/* Combat Queue */
@property CombatQueue *combatQueue;

/* HEROS MOVE */
@property (strong, nonatomic) NSString *heroMoveName;
@property BOOL critHit;

// Turn number
@property int turnNumber;

/* Scroll Views */
@property (strong, nonatomic) IBOutlet UIScrollView *heroScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *enemyScrollView;

/* Text Strings */
// represents the text at the moment, constantly reset
@property NSAttributedString *combatTextTmpString;
@property NSMutableAttributedString *fullCombatTextString; // represents the extend text of the whole fight, updated every change in combat text

/* Views */
@property (strong, nonatomic) IBOutlet UITextView *CombatText; // actual text view

@property (strong, nonatomic) UITextView *moveView; // Pop up box Long Press (Enemy Status)



-(void)initCombat;
-(void)heroManageBuffs:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;
-(int)heroDamageReduction:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage Enemy:(Enemy*)e;
-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage;
-(void)critChance:(int)extraChance;


@end
