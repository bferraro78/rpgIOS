//
//  Heal.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Heal.h"
@implementation Heal

int healResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _healResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.healResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap {
    printf("Heal!!");
    
    /* Insert Heal Dot */
    int heal = -(mainCharacter.inti/2);
    
    mainCharacter.buffLibrary[@"healDot"] = [[Buff alloc] initvalue:heal duration:3];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    printf("Enemey uses Heal...");
    
    /* Insert Heal Dot */
    int heal = -(e.enemyInti/2);
    
    mainCharacter.buffLibrary[@"healDot"] = [[Buff alloc] initvalue:heal duration:3];
    
}

@end