//
//  HeroPartyMember.h
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef HeroPartyMember_h
#define HeroPartyMember_h
#import "Hero.h"
#import "PartyMember.h"

@interface HeroPartyMember : PartyMember

@property BOOL readyCheck;

-(id)initWith:(Being*)aPartyMemberHero readyCheck:(BOOL)readyCheck;

@end

#endif /* HeroPartyMember_h */
