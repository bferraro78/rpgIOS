//
//  Fireball.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Fireball_h
#define Fireball_h
#import "Enemy.h"
#import "Skill.h"
#import "Buff.h"

@interface Fireball : Skill

@property int fireballResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;

-(int)getCombatResourceCost:(int)totalResource;
-(NSString*)getMoveDescription;
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;


@end

#endif /* Fireball_h */
