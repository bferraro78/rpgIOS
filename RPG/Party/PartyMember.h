//
//  PartyMember.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyMember_h
#define PartyMember_h
#import "MainCharacter.h"

@interface PartyMember : NSObject

@property Hero *partyMemberHero; // Has only the info needed for the mainCharacter's purposes
@property BOOL readyCheck;

-(id)initWith:(Hero*)aPartyMemberHero readyCheck:(BOOL)readyCheck;
-(NSMutableDictionary*)partyMemberToDictionary;
-(void)loadExistingPartyMemberFromDictionary:(NSDictionary*)partyMemberDictionary;

@end
#endif /* PartyMember_h */
