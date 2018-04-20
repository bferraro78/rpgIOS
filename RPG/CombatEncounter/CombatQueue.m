//
//  CombatQueue.m
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CombatQueue.h"

@implementation CombatQueue

/*
    CombatQueue array is generated in CombatManager.m
    Holds Hero and Enemy PartyMember objects
*/

-(id)initCombatQueue {
    _combatQueue = [[NSMutableArray alloc] init];
    return self;
}

-(id)initWithCombatQueue:(NSMutableArray*)combatQueue {
    _combatQueue = combatQueue;
    return self;
}

-(void)enqueuePartyMember:(id)partyMember {
    [_combatQueue addObject:partyMember];
}

-(PartyMember*)dequeuePartyMember {
    PartyMember *headObject = [_combatQueue objectAtIndex:0];
    PartyMember *returnPartyMember = nil;
    
    if (headObject != nil) {
        // Check if enemypartyMember or heroPartyMember
        returnPartyMember = headObject;
        [_combatQueue removeObjectAtIndex:0];
    }
    return returnPartyMember;
}


-(NSMutableArray*)combatOrderToDictionary {
    NSMutableArray *combatOrderArrayDictionary = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [_combatQueue count]; i++) {
        PartyMember *pm = [_combatQueue objectAtIndex:i];
        [combatOrderArrayDictionary addObject:[pm partyMemberToDictionary]];
    }
    
    return combatOrderArrayDictionary;
}

-(void)loadCombatOrderFromDictionary:(NSDictionary*)combatOrderDictionary {
    NSArray *combatOrderArray = combatOrderDictionary[@"combatOrder"];
    for (int i = 0; i < [combatOrderArray count]; i++) {
        NSDictionary *pmDictionary = [combatOrderArray objectAtIndex:i];
        Being *b = [CreateClassManager loadPartyMemberBeing:pmDictionary];
        PartyMember *pm;
        
        if ([pmDictionary[@"class"] isEqualToString:ENEMY]) {
            pm = [[EnemyPartyMember alloc] initWith:b indexOfEnemyPartyMember:[pmDictionary[@"indexOfEnemy"] intValue]];
        } else { // not an enemy
            pm = [[HeroPartyMember alloc] initWith:b readyCheck:false];
        }
        
        [_combatQueue addObject:pm];
    }
}


@end
