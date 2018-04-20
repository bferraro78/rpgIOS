//
//  CombatQueue.h
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef CombatQueue_h
#define CombatQueue_h
#import "Party.h"
#import "EnemyParty.h"
#import "CreateClassManager.h"

@interface CombatQueue : NSObject

@property NSMutableArray *combatQueue;

-(id)initCombatQueue;
-(id)initWithCombatQueue:(NSMutableArray*)combatQueue;
-(void)enqueuePartyMember:(id)partyMember;
-(PartyMember*)dequeuePartyMember;

-(NSMutableArray*)combatOrderToDictionary;
-(void)loadCombatOrderFromDictionary:(NSDictionary*)combatOrderDictionary;
@end

#endif /* CombatQueue_h */
