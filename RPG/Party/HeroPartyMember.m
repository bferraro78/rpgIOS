//
//  HeroPartyMember.m
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroPartyMember.h"
@implementation HeroPartyMember

-(id)initWith:(Being*)aPartyMemberHero readyCheck:(BOOL)readyCheck {
    self.partyMember = aPartyMemberHero;
    _readyCheck = readyCheck;
    return self;
}

/* Package a whole party member object to be sent to all other users during combat */
-(NSMutableDictionary*)partyMemberToDictionary {
    NSMutableDictionary* jsonable = [self.partyMember beingToDictionary];
    
    NSString *readyString = (_readyCheck) ? READY : NOTREADY;
    jsonable[@"readyCheck"] = readyString;
    
    return jsonable;
}

-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary {
    // update party member hero w/o losing mainCharacter reference
    self.partyMember = [self.partyMember loadBeingFromDictionary:partyMemberDictionary];
    NSString *readyString = partyMemberDictionary[@"readyCheck"];
    _readyCheck = ([readyString isEqualToString:READY]) ? true : false;
}

@end
