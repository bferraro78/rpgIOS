//
//  CombatManager.m
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CombatManager.h"

@implementation CombatManager

+(void)generateEnemyParty:(Party*)heroParty {
    
    EnemyParty *ep = [EnemyParty getEnemyPartyArray];
    EnemyPartyMember *e = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:0];
    
    EnemyPartyMember *e1 = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:1];
    
    EnemyPartyMember *e2 = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:2];
    
    EnemyPartyMember *e3 = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:3];
    
    EnemyPartyMember *e4 = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:4];
    
    EnemyPartyMember *e5 = [[EnemyPartyMember alloc] initWith:[EnemyDictionary generateRandomEnemy] indexOfEnemyPartyMember:5];
    
    [ep addToParty:e];
    [ep addToParty:e1];
    [ep addToParty:e2];
    [ep addToParty:e3];
    [ep addToParty:e4];
    [ep addToParty:e5];
}

+(NSMutableArray*)createCombatOrder:(Party*)heroParty enemyParty:(EnemyParty*)enemyParty {
    NSMutableArray *combatOrderBeings = [[NSMutableArray alloc] init];
    
    /* Load Hero and Enemy objects */
    for (int i = 0; i < [heroParty partyCount]; i++) {
        HeroPartyMember *h = [heroParty partyMemberAtIndex:i];
        [combatOrderBeings addObject:h];
    }

    for (int i = 0; i < [enemyParty enemyPartyCount]; i++) {
        EnemyPartyMember *e = [enemyParty enemyPartyMemberAtIndex:i];
        [combatOrderBeings addObject:e];
    }

    /* Begin Bubble sort (in-place) */
    for (int i = 0; i < [combatOrderBeings count]-1; i++) {
        for (int j = 0; j < [combatOrderBeings count]-1; j++) {
            PartyMember *pm = [combatOrderBeings objectAtIndex:j];
            PartyMember *pmLater = [combatOrderBeings objectAtIndex:j+1];
            if (pm.partyMember.dext < pmLater.partyMember.dext) {
                [combatOrderBeings exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    
    return combatOrderBeings;
}

@end
