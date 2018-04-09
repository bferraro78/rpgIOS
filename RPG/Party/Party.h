//
//  Party.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef Party_h
#define Party_h
#import "PartyMember.h"

@interface Party : NSObject

@property (nonatomic, strong) NSMutableArray *PartyArray;

+(Party*)getPartyArray;
-(void)addToParty:(PartyMember*)partyMember;
-(void)removeFromParty:(PartyMember*)partyMember;
-(PartyMember*)getPartyMember:(NSString*)partyMemberName;
-(int)indexOfPartyMember:(NSString*)peerDisplayName;
-(int)partyCount;
@end
#endif /* Party_h */
