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


-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext
       startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl {
    [super initname:aName classID:aClassID vit:aVit strn:aStrn inti:aInti dext:aDext startX:aStartX startY:aStartY dungeonLvl:aDungeonLvl];
    
    [self loadSkills];
    [self setResource];
    _combatMana = self.mana;
    return self;
}

-(void)loadSkills {
    [super addSkill:@"Basic Attack"];
    [super addSkill:@"Fireball"];
    [super addSkill:@"Heal"];
    
    if (super.level >= 5) {
        [super addSkill:@"FreezeCone"];
    }
    // ElementAbilites.getElementalAbilities(this);
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



