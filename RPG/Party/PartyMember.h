//
//  PartyMember.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyMember_h
#define PartyMember_h
#import "Being.h"

@interface PartyMember : NSObject

@property Being *partyMember;

-(NSMutableDictionary*)partyMemberToDictionary;
-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary;

@end
#endif /* PartyMember_h */
