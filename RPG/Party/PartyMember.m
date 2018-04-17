//
//  PartyMember.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartyMember.h"

@implementation PartyMember

-(id)initWith:(Hero*)aPartyMemberHero readyCheck:(BOOL)readyCheck {
    _partyMemberHero = aPartyMemberHero;
    _readyCheck = readyCheck;
    return self;
}

/* Package a whole party member object to be sent to all other users during combat */
-(NSMutableDictionary*)partyMemberToDictionary {
    NSMutableDictionary* jsonable = [_partyMemberHero heroPartyMemberToDictionary];
    
    NSString *readyString = (_readyCheck) ? READY : NOTREADY;
    jsonable[@"readyCheck"] = readyString;
    
    return jsonable;
}

-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary {
    // update party member hero w/o losing mainCharacter reference
    _partyMemberHero = [_partyMemberHero loadPartyMemberHero:partyMemberDictionary];
    NSString *readyString = partyMemberDictionary[@"readyCheck"];
    _readyCheck = ([readyString isEqualToString:READY]) ? true : false;   
}

@end
