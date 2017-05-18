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


-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext
       startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl {
    [super initname:aName classID:aClassID vit:aVit strn:aStrn inti:aInti dext:aDext startX:aStartX startY:aStartY dungeonLvl:aDungeonLvl];
    
    _combatRage = 0;
    _rage = 100;
    [self loadSkills];
    return self;
}

-(void)loadSkills {
    [super addSkill:@"BasicAttack"];
    [super addSkill:@"Frenzy"];
    [super addSkill:@"Heal"];
    
    if (super.level >= 5) {
        [super addSkill:@"Rend"];
    }
    // ElementAbilites.getElementalAbilities(this);
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