//
//  Wizard.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Wizard_h
#define Wizard_h
#import "Hero.h"

@class Wziard;
@interface Wizard : Hero

@property int mana;
@property int combatMana;

-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext;
-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats;

-(void)loadSkills;

-(void)setResource;
-(NSString*)getResourceName;
-(void)increaseResource:(int)manaIncrease;
-(void)useCombatResource:(int)resourceUsed;
-(void)regenCombatResource:(int)resourceGain;
-(void)resetCombatResource;
-(int)getResource;
-(int)getCombatResource;


@end

#endif /* Wizard_h */
