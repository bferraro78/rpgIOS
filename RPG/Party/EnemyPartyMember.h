//
//  EnemyPartyMember.h
//  RPG
//
//  Created by james schuler on 4/16/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EnemyPartyMember_h
#define EnemyPartyMember_h
#import "Enemy.h"
#import "PartyMember.h"

@interface EnemyPartyMember : PartyMember

@property int indexOfEnemyPartyMember;

-(id)initWith:(Being*)aPartyMemberEnemy indexOfEnemyPartyMember:(int)indexOfEnemyPartyMember;

@end

#endif /* EnemyPartyMember_h */
