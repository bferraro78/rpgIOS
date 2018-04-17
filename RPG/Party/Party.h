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
-(void)removeFromParty:(NSString*)partyMember;

-(PartyMember*)getPartyMember:(NSString*)partyMemberName;
-(int)indexOfPartyMember:(NSString*)peerDisplayName;
-(PartyMember*)partyMemberAtIndex:(NSInteger*)index;

-(int)partyCount;
-(void)clearParty;

//-(NSMutableDictionary*)partyToDictionary;
//-(void)loadUpdatedPartyHeroesFromDictionary:(NSDictionary*)partyDictionary;

-(int)readyCheckCount;

-(PartyMember*)getPartyLeader;

@end
#endif /* Party_h */
