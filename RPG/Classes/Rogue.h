//
//  Rogue.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Rogue_h
#define Rogue_h
#import "Hero.h"

@class Rogue;
@interface Rogue : Hero

@property int energy;
@property int combatEnergy;

-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext;
-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats;

-(void)loadSkills;

-(NSString*)getResourceName;
-(void)increaseResource:(int)energyIncrease;
-(void)useCombatResource:(int)resourceUsed;
-(void)regenCombatResource:(int)resourceGain;
-(void)resetCombatResource;
-(int)getResource;
-(int)getCombatResource;



@end

#endif /* Rogue_h */
