//
//  CombatViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/24/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hero.h"
#import "Enemy.h"
#import "EnemyDictionary.h"
#import "SkillDictionary.h"
#import "ItemDictionary.h"
#import "BuffDictionary.h"
@interface CombatViewController : UIViewController

/* Hero Spec */
@property BOOL lightningSpecAdditionalTurn;

@property NSMutableDictionary *heroElementMap;
@property NSMutableDictionary *enemyElementMap;

// Timer
@property NSUInteger critTimerCount;
@property NSTimer *timer;
@property BOOL critHit;

@property (strong, nonatomic) IBOutlet UITextView *CombatText;
@property (strong, nonatomic) IBOutlet UITextView *HeroBuffsDebuffs;
@property (strong, nonatomic) IBOutlet UITextView *EnemyBuffsDebuffs;

@property NSMutableAttributedString *combatSetText;

@property(nonatomic) Hero *mainCharacter;
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


-(void)initCombat:(Hero*)mainCharacter;
-(void)heroManageBuffs:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter;

-(int)heroDamageReduction:(Hero*)mainCharacter EnemyDamageMap:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage Enemy:(Enemy*)e;
-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage Hero:(Hero*)mainCharacter;
-(void)critChance:(int)extraChance Hero:(Hero*)mainCharacter;


@end
