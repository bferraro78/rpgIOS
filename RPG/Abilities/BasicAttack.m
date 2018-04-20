//
//  BasicAttack.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicAttack.h"
@implementation BasicAttack

int basicattackResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _basicattackResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource {
    return 0; // (int)((float)(self.basicattackResourceCost/100.0)*(float)totalResource);
}

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"Strike the enemy for %i %s damage.",
            [self getHeroDamageAverage], [[mainCharacter getMH].weaponElement UTF8String]];
}

-(int)getHeroDamageAverage {
    return (mainCharacter.level+[mainCharacter getPrimaryStat]+5)+([[mainCharacter getMH] attack]+
                                                            [[mainCharacter getOH] attack]);
}

-(int)getHeroDamage {
    return (mainCharacter.level+[mainCharacter getPrimaryStat]+5)+([[mainCharacter getMH] getSwing]+
                                                                   [[mainCharacter getOH] getSwing]);
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("BasicAttack\n");
    
    /* Insert Damage */
    int damage = [self getHeroDamage];
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /** Rage is increased by Basic Attacks, reset if regen past full **/
    if ([[mainCharacter getResourceName] isEqualToString:RAGE]) {
        int regen = 12;
        if ([mainCharacter getCombatResource]+regen  <= [mainCharacter getResource]) {
            [mainCharacter regenCombatResource:regen];
        } else {
            /* Set to max rage */
            [mainCharacter setMaxCombatResource];
        }
    }
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemy Uses Basic Attack\n");
    
    /* Insert Damage */
    int damage = (e.strn+e.inti+e.dext);
    
    NSString *element = e.elementSpec;
    elementMap[element] = [NSNumber numberWithInt:damage];
}


@end
