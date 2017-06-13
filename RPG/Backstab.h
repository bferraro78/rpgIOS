//
//  Backstab.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Backstab_h
#define Backstab_h
#import "Hero.h"
#import "Enemy.h"
#import "Skill.h"
#import "Buff.h"
@interface Backstab : Skill

@property int backstabResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;


-(int)getCombatResourceCost:(int)totalResource;
-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter;


@end

#endif /* Backstab_h */
