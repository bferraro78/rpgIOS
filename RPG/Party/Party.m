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
    return [self.PartyArray objectAtIndex:index];
}

-(int)partyCount {
    return [self.PartyArray count];
}

-(void)clearParty {
    [self.PartyArray removeAllObjects];
}

@end
