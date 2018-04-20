//
//  Enemy.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Enemy_h
#define Enemy_h
#import "Being.h"
#import "MainCharacter.h"

@class Enemy;
@interface Enemy : Being

@property int enemyArmor;
@property int enemyExp;


// Don't need to package and send?
@property NSMutableArray *enemySkillSet;

@property NSMutableArray *poisonPassiveDots; // holding poison damages from hero poison specs

@property NSMutableDictionary *combatDamageElementMap;

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

-(void)takeDamage:(int)healthReductionOrIncrease;

-(id)loadEnemyBeingFromDictionary:(NSDictionary*)partyEnemyStats;

-(NSMutableString*)printStats;

@end


#endif /* Enemy_h */
