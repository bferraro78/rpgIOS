//
//  EnemyPartyMember.m
//  RPG
//
//  Created by james schuler on 4/16/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyPartyMember.h"

@implementation EnemyPartyMember


-(id)initWith:(Being*)aPartyMemberEnemy indexOfEnemyPartyMember:(int)indexOfEnemyPartyMember {
    self.partyMember = aPartyMemberEnemy;
    _indexOfEnemyPartyMember = indexOfEnemyPartyMember;
    return self;
}

/* Package a whole party enemy member object to be sent to all other users during combat */
-(NSMutableDictionary*)partyMemberToDictionary {
    NSMutableDictionary* jsonable = [self.partyMember beingToDictionary];
    jsonable[@"indexOfEnemy"] = [NSString stringWithFormat:@"%i", _indexOfEnemyPartyMember];
    return jsonable;
}

-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary {
    // update party member enemy
    self.partyMember = [self.partyMember loadBeingFromDictionary:partyMemberDictionary];
    _indexOfEnemyPartyMember = [partyMemberDictionary[@"indexOfEnemy"] intValue];
}



@end
