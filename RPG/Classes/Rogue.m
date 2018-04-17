//
//  Rogue.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rogue.h"
@implementation Rogue

int energy;
int combatEnergy;


-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext {
    
    self = [super initNewCharacterName:aName vit:aVit strn:aStrn inti:aInti dext:aDext];
    
    self.classID = 3;
    [self loadSkills];
    _energy = 100;
    _combatEnergy = self.energy;
    return self;
}

-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats {
    [super loadPartyMemberHero:partyHeroStats];
    self.classID = 3;
    _energy = 100;
    _combatEnergy = self.energy;
    return self;
}

-(void)loadSkills {
    [super addSkillIfNotAlreadyKnown:BASICATTACK];
    [super addSkillIfNotAlreadyKnown:BACKSTAB];
    
    if (super.level >= 5) {
        [super addSkillIfNotAlreadyKnown:VANISH];
    }
}

-(NSString*)getResourceName { return ENERGY; }
-(int)getResource { return self.energy; }
-(int)getCombatResource { return self.combatEnergy; }
-(void)increaseResource:(int)energyIncrease { self.energy = energyIncrease; }
-(void)useCombatResource:(int)resourceUsed { self.combatEnergy = (self.combatEnergy-resourceUsed); }
-(void)regenCombatResource:(int)resourceGain { self.combatEnergy = (self.combatEnergy+resourceGain); }
-(void)resetCombatResource { self.combatEnergy = self.energy; }


@end
