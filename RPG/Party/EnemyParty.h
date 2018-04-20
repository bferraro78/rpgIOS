//
//  EnemyParty.h
//  RPG
//
//  Created by james schuler on 4/16/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EnemyParty_h
#define EnemyParty_h
#import "Enemy.h"
#import "EnemyPartyMember.h"
#import "CreateClassManager.h"

/** An array of enemies, used for combat **/
@interface EnemyParty : NSObject

@property (nonatomic, strong) NSMutableArray *EnemyPartyArray;

+(EnemyParty*)getEnemyPartyArray;
-(void)addToParty:(EnemyPartyMember*)enemyPartyMember;
-(void)removeFromParty:(NSString*)enemyPartyMemberName;
-(NSInteger)indexOfEnemyPartyMember:(NSString*)enemyName;
-(EnemyPartyMember*)enemyPartyMemberAtIndex:(int)index;
-(NSInteger)enemyPartyCount;
-(void)clearParty;

-(NSMutableDictionary*)enemyPartyToDictionary;
-(void)loadPartyEnemiesFromDictionary:(NSDictionary*)partyDictionary;

@end

#endif /* EnemyParty_h */
