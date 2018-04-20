//
//  Party.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Party.h"
@implementation Party

@synthesize PartyArray;

#pragma mark Singleton Methods

+(Party*)getPartyArray {
    static Party *PartyArray = nil; // only called first time?
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        PartyArray = [[self alloc] init];
    });
    return PartyArray;
}

-(id)init {
    self.PartyArray = [[NSMutableArray alloc] init];
    return self;
}

// Add to party if not already in party
-(void)addToParty:(HeroPartyMember*)partyMember {
    BOOL alreadyInParty = false;
    for (int i = 0; i < [self partyCount]; i++) {
        HeroPartyMember *member = (HeroPartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMember.partyMember.name isEqualToString:member.partyMember.name]) {
            alreadyInParty = true;
        }
    }
    if (!alreadyInParty) {
        [self.PartyArray addObject:partyMember];
    }
}

-(void)removeFromParty:(NSString*)partyMemberName {
    for (int i = 0; i < [self partyCount]; i++) {
        HeroPartyMember *member = (HeroPartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMemberName isEqualToString:member.partyMember.name]) {
            [self.PartyArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(HeroPartyMember*)getPartyMember:(NSString*)partyMemberName {
    HeroPartyMember *ret = nil;
    for (int i = 0; i < [self partyCount]; i++) {
        HeroPartyMember *member = (HeroPartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMemberName isEqualToString:member.partyMember.name]) {
            ret = member;
            break;
        }
    }
    return ret;
}

-(int)readyCheckCount {
    int readyCount = 0;
    Party *p = [Party getPartyArray];
    for (int i = 0; i < [p partyCount]; i++) {
        HeroPartyMember *member = (HeroPartyMember*)[p.PartyArray objectAtIndex:i];
        if (member.readyCheck) {
            readyCount++;
        }
    }
    return readyCount;
}

-(NSInteger)indexOfPartyMember:(NSString*)peerDisplayName {
    return [self.PartyArray indexOfObject:peerDisplayName];
}

-(PartyMember*)partyMemberAtIndex:(int)index {
    return [self.PartyArray objectAtIndex:index];
}

-(int)partyCount {
    return [self.PartyArray count];
}

-(void)clearParty {
    [self.PartyArray removeAllObjects];
}



/* NOT THE ACTUAL PARTY LEADER - JUST TO ENSURE THAT SOME FUNCTIONS ARE DONE
   BY ONE PHONE IN CASE OF RANDOMNESS
 
 USE PARTY LEADER TO:
 1. Generate combat turn order
 2. Generate enemies
 3. Generate loot */
-(HeroPartyMember*)getPartyLeader {
    Party *p = [Party getPartyArray];
    
    /* Start with first member of group, compare to other based on alphabet */
    HeroPartyMember *CurrentLeader = [p partyMemberAtIndex:0];
    for (int i = 1; i < [p partyCount]; i++) {
        HeroPartyMember *tmpLeader = [p partyMemberAtIndex:i];
        if ([CurrentLeader.partyMember.name compare:tmpLeader.partyMember.name] == NSOrderedDescending) {
            CurrentLeader = tmpLeader;
        }
    }
    return CurrentLeader;
}

@end
