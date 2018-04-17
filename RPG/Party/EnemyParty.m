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

-(void)addToParty:(Enemy*)enemyPartyMember {
    [self.EnemyPartyArray addObject:enemyPartyMember];
}

-(void)removeFromParty:(NSString*)enemyPartyMemberName {
    for (int i = 0; i < [self enemyPartyCount]; i++) {
        Enemy *enemy = (Enemy*)[self.EnemyPartyArray objectAtIndex:i];
        if ([enemyPartyMemberName isEqualToString:enemy.enemyName]) {
            [self.EnemyPartyArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(Enemy*)getEnemyPartyMember:(NSString*)enemyPartyMemberName {
    Enemy *ret = nil;
    for (int i = 0; i < [self enemyPartyCount]; i++) {
        Enemy *enemy= (Enemy*)[self.EnemyPartyArray objectAtIndex:i];
        if ([enemyPartyMemberName isEqualToString:enemy.enemyName]) {
            ret = enemy;
            break;
        }
    }
    return ret;
}

-(NSInteger)indexOfEnemyPartyMember:(NSString*)enemyName {
    return [self.EnemyPartyArray indexOfObject:enemyName];
}

-(Enemy*)enemyPartyMemberAtIndex:(NSInteger*)index {
    return [self.EnemyPartyArray objectAtIndex:(int)index];
}

-(NSInteger)enemyPartyCount {
    return [self.EnemyPartyArray count];
}

-(void)clearParty {
    [self.EnemyPartyArray removeAllObjects];
}





@end
