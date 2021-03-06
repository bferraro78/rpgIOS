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

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _backstabResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.backstabResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e {
    printf("BackStab!!");
    
    /* Insert Damage */
    int damage = ((mainCharacter.level*15)+mainCharacter.dext)+([[mainCharacter getMH] getSwing]+
                                                                [[mainCharacter getOH] getSwing]);
    
    NSString *element = [mainCharacter getMH].weaponElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /* 50% extra crit chance */
    mainCharacter.buffLibrary[@"critDamage"] = [[Buff alloc] initvalue:50 duration:0];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses BackStab...");
    
    /* Insert Damage */
    int damage = (e.enemyDext+(5*mainCharacter.level));
    NSString *element = e.enemyElement;
    elementMap[element] = [NSNumber numberWithInt:damage];
    
    /* 50% extra crit chance */
    e.enemyBuffLibrary[@"critDamage"] = [[Buff alloc] initvalue:50 duration:0];

}


@end
