//
//  Wizard.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wizard.h"

@implementation Wizard

int mana;
int combatMana;


-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext {
   
    self = [super initNewCharacterName:aName vit:aVit strn:aStrn inti:aInti dext:aDext];
    
    self.classID = 2;
    [self loadSkills];
    [self setResource];
    _combatMana = self.mana;
    return self;
}

-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats {
    [super loadPartyMemberHero:partyHeroStats];
    self.classID = 2;
    [self setResource];
    _combatMana = self.mana;
    
    return self;
}

-(void)loadSkills {
    [super addSkillIfNotAlreadyKnown:@"Basic Attack"];
    [super addSkillIfNotAlreadyKnown:@"Fireball"];
    
    if (super.level >= 5) {
        [super addSkillIfNotAlreadyKnown:@"Freezecone"];
    }
    
}


-(void)setResource {self.mana = 100+super.inti; }
-(int)getResource { return self.mana; }
-(int)getCombatResource {return self.combatMana; }
-(NSString*)getResourceName { return @"Mana"; }
-(void)increaseResource:(int)manaIncrease { self.mana = manaIncrease; }
-(void)useCombatResource:(int)resourceUsed { self.combatMana = (self.combatMana-resourceUsed); }
-(void)regenCombatResource:(int)resourceGain { self.combatMana = (self.combatMana+resourceGain); }
-(void)resetCombatResource { self.combatMana = self.mana; }




@end



