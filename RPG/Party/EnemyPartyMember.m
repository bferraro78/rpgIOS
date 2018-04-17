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


-(id)initWith:(Enemy*)aPartyMemberEnemy {
    _partyMemberEnemy = aPartyMemberEnemy;
    return self;
}

/* Package a whole party enemy member object to be sent to all other users during combat */
-(NSMutableDictionary*)partyMemberToDictionary {
    NSMutableDictionary* jsonable = [_partyMemberEnemy enemyPartyMemberToDictionary];
    return jsonable;
}

-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary {
    // update party member enemy
    _partyMemberEnemy = [_partyMemberEnemy loadPartyMemberEnemy:partyMemberDictionary];
}



@end
