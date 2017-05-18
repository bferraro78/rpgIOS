//
//  Combat.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Combat_h
#define Combat_h
#import "Enemy.h"
#import "Hero.h"
#import "EnemyDictionary.h"
#import "SkillDictionary.h"
#import "ItemDictionary.h"
#import "BuffDictionary.h"
@interface Combat : NSObject


+(void)initCombat:(Hero*)mainCharacter;
+(void)heroManageBuffs:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap;
+(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;
+(int)heroDamageReduction:(Hero*)mainCharacter EnemyDamageMap:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage;
+(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage;
+(BOOL)critChance:(int)extraChance Hero:(Hero*)mainCharacter;

@end

#endif /* Combat_h */
