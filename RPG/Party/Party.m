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
-(void)addToParty:(PartyMember*)partyMember {
    BOOL alreadyInParty = false;
    for (int i = 0; i < [self partyCount]; i++) {
        PartyMember *member = (PartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMember.partyMemberHero.name isEqualToString:member.partyMemberHero.name]) {
            alreadyInParty = true;
        }
    }
    if (!alreadyInParty) {
        [self.PartyArray addObject:partyMember];
    }
}

-(void)removeFromParty:(NSString*)partyMemberName {
    for (int i = 0; i < [self partyCount]; i++) {
        PartyMember *member = (PartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMemberName isEqualToString:member.partyMemberHero.name]) {
            [self.PartyArray removeObjectAtIndex:i];
            break;
        }
    }
}

-(PartyMember*)getPartyMember:(NSString*)partyMemberName {
    PartyMember *ret = nil;
    for (int i = 0; i < [self partyCount]; i++) {
        PartyMember *member = (PartyMember*)[self.PartyArray objectAtIndex:i];
        if ([partyMemberName isEqualToString:member.partyMemberHero.name]) {
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
        PartyMember *member = (PartyMember*)[p.PartyArray objectAtIndex:i];
        if (member.readyCheck) {
            readyCount++;
        }
    }
    return readyCount;
}

-(int)indexOfPartyMember:(NSString*)peerDisplayName {
    return [self.PartyArray indexOfObject:peerDisplayName];
}

-(PartyMember*)partyMemberAtIndex:(NSInteger*)index {
    return [self.PartyArray objectAtIndex:(int)index];
}

-(int)partyCount {
    return [self.PartyArray count];
}

-(void)clearParty {
    [self.PartyArray removeAllObjects];
}

/* Package a whole party object to be sent to all other users */
//-(NSMutableDictionary*)partyToDictionary {
//    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
//    NSMutableArray *partyArray = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < [self partyCount]; i++) {
//        PartyMember *pm = [self partyMemberAtIndex:i];
//        [partyArray addObject:[pm partyMemberToDictionary]];
//    }
//    
//    jsonable[@"party"] = partyArray; // [PartyMember Dic One, PartyMember Dic Two,...]
//    jsonable[@"action"] = @"updateHeroPartyNotification";
//    return jsonable;
//}

/* WARNING: MUST ONLY SEND OUT YOUR VERSION OF THE PARTY/ENEMY PARTY WHEN YOU KNOW
            NO ONE ELSE BUT YOU HAS CHANGED A PARTY OR ENEMYPARTY
            1. Used after a turn in combat. The turn by turn nature allows you
               to assume that only you have changed the either party.
            2. If your character is being updated based on someones elses party info,
               Instead just update the hero's stats DO NOT RESET THE MAINCAHRACTER REFERENCE OR CREATE A NEW Hero*
 */
//-(void)loadUpdatedPartyHeroesFromDictionary:(NSDictionary*)partyDictionary {
//    NSMutableArray *partyArray = partyDictionary[@"party"];
//    for (int i = 0; i < [partyArray count]; i++) {
//        NSDictionary *partyMemberDictionary = [partyArray objectAtIndex:i];
//        NSString *partyMemberName = partyMemberDictionary[@"name"];
//        // Update Party Member
//        PartyMember *m = [self getPartyMember:partyMemberName];
//        [m loadExistingPartyMemberFromDictionary:partyMemberDictionary];
//    }
//}


/* NOT THE ACTUAL PARTY LEADER - JUST TO ENSURE THAT SOME FUNCTIONS ARE DONE
   BY ONE PHONE IN CASE OF RANDOMNESS
 
 USE PARTY LEADER TO:
 1. Generate combat turn order
 2. Generate enemies
 3. Generate loot */
-(PartyMember*)getPartyLeader {
    Party *p = [Party getPartyArray];
    
    /* Start with first member of group, compare to other based on alphabet */
    PartyMember *CurrentLeader = [p partyMemberAtIndex:0];
    for (int i = 1; i < [p partyCount]; i++) {
        PartyMember *tmpLeader = [p partyMemberAtIndex:i];
        if ([CurrentLeader.partyMemberHero.name compare:tmpLeader.partyMemberHero.name] == NSOrderedDescending) {
            CurrentLeader = tmpLeader;
        }
    }
    return CurrentLeader;
}

@end
