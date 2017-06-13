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

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _basicattackResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.basicattackResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("BasicAttack\n");
    
    /* Insert Damage */
    int damage = (mainCharacter.level+[mainCharacter getPrimaryStat]+5)+([[mainCharacter getMH] getSwing]+
                                                                         [[mainCharacter getOH] getSwing]);
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /** Rage is increased by Basic Attacks, reset if regen past full **/
    if ([[mainCharacter getResourceName] isEqualToString:@"Rage"]) {
        int regen = 12;
        if ([mainCharacter getCombatResource]+regen  <= [mainCharacter getResource]) {
            [mainCharacter regenCombatResource:regen];
        } else {
            /* Set to max rage */
            [mainCharacter setMaxCombatResource];
        }
    }
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    printf("Enemy Uses Basic Attack\n");
    
    /* Insert Damage */
    int damage = (e.enemyStrn+e.enemyInti+e.enemyDext);
    
    NSString *element = e.enemyElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
}


@end