//
//  Barbarian.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Barbarian.h"
@implementation Barbarian

int rage;
int combatRage;


-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext {
    
    self = [super initNewCharacterName:aName vit:aVit strn:aStrn inti:aInti dext:aDext];
    
    self.classID = 1;
    _combatRage = 0;
    _rage = 100;
    [self loadSkills];
    return self;
}

-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats {
    [super loadPartyMemberHero:partyHeroStats];
    self.classID = 1;
    _combatRage = 0;
    _rage = 100;
    return self;
}

-(void)loadSkills {
    [super addSkillIfNotAlreadyKnown:@"Basic Attack"];
    [super addSkillIfNotAlreadyKnown:@"Frenzy"];
    
    if (super.level >= 5) {
        [super addSkillIfNotAlreadyKnown:@"Rend"];
    }
}

-(NSString*)getResourceName { return @"Rage"; }
-(void)increaseResource:(int)rageIncrease { self.rage = rageIncrease; }
-(void)useCombatResource:(int)resourceUsed { self.combatRage = (self.combatRage-resourceUsed); }
-(void)regenCombatResource:(int)resourceGain { self.combatRage = (self.combatRage+resourceGain); }
-(void)resetCombatResource { self.combatRage = 0; }
-(void)setMaxCombatResource { self.combatRage = self.rage; }
-(int)getResource { return self.rage; }
-(int)getCombatResource { return self.combatRage; }



@end
