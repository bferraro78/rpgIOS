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

@interface EnemyPartyMember : NSObject

@property Enemy *partyMemberEnemy;

-(id)initWith:(Enemy*)aPartyMemberEnemy;
-(NSMutableDictionary*)partyMemberToDictionary;
-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary;

@end

#endif /* EnemyPartyMember_h */
