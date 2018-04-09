//
//  Enemy.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Enemy_h
#define Enemy_h
#import "MainCharacter.h"

@class Enemy;
@interface Enemy : NSObject

@property NSString *enemyName;
@property int enemyHealth;
@property int enemyCombatHealth;
@property int enemyStrn;
@property int enemyInti;
@property int enemyDext;
@property int enemyArmor;
@property int enemyExp;
@property NSString *enemyElement;

@property NSMutableArray *enemySkillSet;
@property NSMutableDictionary *enemyBuffLibrary;
@property NSMutableDictionary *enemyDebuffLibrary;


-(id)initenemyName:(NSString*)aEnemyName enemyElement:(NSString*)aEnemyElement enemySkillSet:(NSMutableArray*)aEnemySkillSet
         enemyStrn:(int)aEnemyStrn enemyInti:(int) aEnemyInti enemyDext:(int)aEnemyDext enemyHealth:(int)aEnemyHealth
        enemyArmor:(int)aEnemyArmor;

-(NSString*)selectAttack;
-(void)setSkills:(NSMutableArray*)skills;

-(int)goldDrop;
-(int)getExp;

-(float)getArmorRating;

-(void)setExp;
-(void)setHealth:(int)health;

-(void)takeDamage:(int)healthReductionOrIncrease;

-(NSMutableString*)printStats;

@end


#endif /* Enemy_h */
