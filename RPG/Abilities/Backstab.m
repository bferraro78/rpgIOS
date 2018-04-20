//
//  Backstab.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backstab.h"
@implementation Backstab

int backstabResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _backstabResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.backstabResourceCost/100.0)*(float)totalResource); }

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"%i %@\nStrike the enemy for %i %s damage. 50%% crit chance increase.",
            [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName], [self getHeroDamageAverage], [[mainCharacter getMH].weaponElement UTF8String]];
}

-(int)getHeroDamageAverage {
    return ((mainCharacter.level*15)+mainCharacter.dext)+([[mainCharacter getMH] attack]+
                                                          [[mainCharacter getOH] attack]);
}

-(int)getHeroDamage {
    return ((mainCharacter.level*15)+mainCharacter.dext)+([[mainCharacter getMH] getSwing]+
                                                          [[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e {
    printf("BackStab!!");
    
    /* Insert Damage */
    int damage = [self getHeroDamage];
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /* 50% extra crit chance */
    mainCharacter.combatBuffLibrary[EXTRACRITICALCHANCE] = [[Buff alloc] initvalue:50 duration:0];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses BackStab...");
    
    /* Insert Damage */
    int damage = (e.dext+(5*mainCharacter.level));
    NSString *element = e.elementSpec;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /* 50% extra crit chance */
    e.enemyBuffLibrary[EXTRACRITICALCHANCE] = [[Buff alloc] initvalue:50 duration:0];

}


@end
