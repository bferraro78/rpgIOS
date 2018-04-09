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


-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext
startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl {
    [super initname:aName classID:aClassID vit:aVit strn:aStrn inti:aInti dext:aDext startX:aStartX startY:aStartY dungeonLvl:aDungeonLvl];
    
    [self loadSkills];
    _energy = 100;
    _combatEnergy = self.energy;
    return self;
}

-(void)loadSkills {
    [super addSkillIfNotAlreadyKnown:@"Basic Attack"];
    [super addSkillIfNotAlreadyKnown:@"Backstab"];
    
    if (super.level >= 5) {
        [super addSkillIfNotAlreadyKnown:@"Vanish"];
    }
}

-(NSString*)getResourceName { return @"Energy"; }
-(int)getResource { return self.energy; }
-(int)getCombatResource { return self.combatEnergy; }
-(void)increaseResource:(int)energyIncrease { self.energy = energyIncrease; }
-(void)useCombatResource:(int)resourceUsed { self.combatEnergy = (self.combatEnergy-resourceUsed); }
-(void)regenCombatResource:(int)resourceGain { self.combatEnergy = (self.combatEnergy+resourceGain); }
-(void)resetCombatResource { self.combatEnergy = self.energy; }


@end
