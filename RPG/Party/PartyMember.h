//
//  PartyMember.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyMember_h
#define PartyMember_h
#import "Hero.h"

@interface PartyMember : NSObject

@property Hero *partyMemberHero; // Has only the info needed for the mainCharacter's purposes
@property BOOL readyCheck;


-(id)initWith:(Hero*)aPartyMemberHero;

@end
#endif /* PartyMember_h */
