//
//  CombatManager.h
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef CombatManager_h
#define CombatManager_h
#import "EnemyParty.h"
#import "EnemyDictionary.h"
#import "EnemyPartyMember.h"

#import "Party.h"

@interface CombatManager : NSObject

+(void)generateEnemyParty:(Party*)heroParty;
+(NSMutableArray*)createCombatOrder:(Party*)heroParty enemyParty:(EnemyParty*)enemyParty;

@end

#endif /* CombatManager_h */
