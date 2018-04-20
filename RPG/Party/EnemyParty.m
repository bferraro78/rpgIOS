//
//  EnemyParty.m
//  RPG
//
//  Created by james schuler on 4/16/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyParty.h"

@implementation EnemyParty

#pragma mark Singleton Methods

+(EnemyParty*)getEnemyPartyArray {
    static EnemyParty *EnemyPartyArray = nil; // only called first time?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        EnemyPartyArray = [[self alloc] init];
    });
    return EnemyPartyArray;
}

-(id)init {
    self.EnemyPartyArray = [[NSMutableArray alloc] init];
    return self;
}

-(void)addToParty:(EnemyPartyMember*)enemyPartyMember {
    [self.EnemyPartyArray addObject:enemyPartyMember];
}

-(void)removeFromParty:(NSString*)enemyPartyMemberName {
    for (int i = 0; i < [self enemyPartyCount]; i++) {
        EnemyPartyMember *enemy = (EnemyPartyMember*)[self.EnemyPartyArray objectAtIndex:i];
        if ([enemyPartyMemberName isEqualToString:enemy.partyMember.name]) {
            [self.EnemyPartyArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(EnemyPartyMember*)getEnemyPartyMember:(NSString*)enemyPartyMemberName {
    EnemyPartyMember *ret = nil;
    for (int i = 0; i < [self enemyPartyCount]; i++) {
        EnemyPartyMember *enemy= (EnemyPartyMember*)[self.EnemyPartyArray objectAtIndex:i];
        if ([enemyPartyMemberName isEqualToString:enemy.partyMember.name]) {
            ret = enemy;
            break;
        }
    }
    return ret;
}

-(NSInteger)indexOfEnemyPartyMember:(NSString*)enemyName {
    return [self.EnemyPartyArray indexOfObject:enemyName];
}

-(EnemyPartyMember*)enemyPartyMemberAtIndex:(int)index {
    return [self.EnemyPartyArray objectAtIndex:index];
}

-(NSInteger)enemyPartyCount {
    return [self.EnemyPartyArray count];
}

-(void)clearParty {
    [self.EnemyPartyArray removeAllObjects];
}


/* These functions are only used to initally pass on the generated enemies! */
-(NSMutableDictionary*)enemyPartyToDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    NSMutableArray *partyArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < [self enemyPartyCount]; i++) {
        EnemyPartyMember *pm = [self enemyPartyMemberAtIndex:i];
        [partyArray addObject:[pm partyMemberToDictionary]];
    }

    jsonable[@"enemyParty"] = partyArray; // [PartyMember Dic One, PartyMember Dic Two,...]
    return jsonable;
}

-(void)loadPartyEnemiesFromDictionary:(NSDictionary*)partyDictionary {
    NSArray *partyArray = partyDictionary[@"enemyParty"];
    for (int i = 0; i < [partyArray count]; i++) {
        NSDictionary *partyMemberDictionary = [partyArray objectAtIndex:i];
        
        Enemy *e = (Enemy*)[CreateClassManager loadPartyMemberBeing:partyMemberDictionary];
        EnemyPartyMember *epm = [[EnemyPartyMember alloc] initWith:e indexOfEnemyPartyMember:[partyMemberDictionary[@"indexOfEnemy"] intValue]];
        [self.EnemyPartyArray addObject:epm];
    }
}


@end
