//
//  EnemyDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef EnemyDictionary_h
#define EnemyDictionary_h
#import "Hero.h"
#import "Enemy.h"
@interface EnemyDictionary : NSObject

@property NSMutableArray *enemyLibrary;

+(void)loadEnemies;
+(Enemy*)generateRandomEnemy:(Hero*)mainCharacter;
+(Enemy*)findEnemy:(NSString*)s;
@end

#endif /* EnemyDictionary_h */
