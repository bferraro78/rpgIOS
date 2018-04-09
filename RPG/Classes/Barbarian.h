//
//  Barbarian.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Barbarian_h
#define Barbarian_h
#import "Hero.h"

@class Barbarian;
@interface Barbarian : Hero

@property int rage;
@property int combatRage;

-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext
       startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl;


-(void)loadSkills;

-(NSString*)getResourceName;
-(void)increaseResource:(int)rageIncrease;
-(void)useCombatResource:(int)resourceUsed;
-(void)regenCombatResource:(int)resourceGain;
-(void)resetCombatResource;
-(void)setMaxCombatResource;
-(int)getResource;
-(int)getCombatResource;

@end

#endif /* Barbarian_h */
