//
//  Party.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef Party_h
#define Party_h
#import "HeroPartyMember.h"

@interface Party : NSObject

@property (nonatomic, strong) NSMutableArray *PartyArray;

+(Party*)getPartyArray;
-(void)addToParty:(HeroPartyMember*)partyMember;
-(void)removeFromParty:(NSString*)partyMember;

-(HeroPartyMember*)getPartyMember:(NSString*)partyMemberName;
-(NSInteger)indexOfPartyMember:(NSString*)peerDisplayName;
-(HeroPartyMember*)partyMemberAtIndex:(int)index;

-(int)partyCount;
-(void)clearParty;

-(int)readyCheckCount;

-(HeroPartyMember*)getPartyLeader;

@end
#endif /* Party_h */
