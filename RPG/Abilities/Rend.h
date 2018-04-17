//
//  Rend.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Rend_h
#define Rend_h
#import "Enemy.h"
#import "Skill.h"
#import "Buff.h"

@interface Rend : Skill

@property int rendResourceCost;

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;
-(int)getCombatResourceCost:(int)totalResource;
-(NSString*)getMoveDescription;
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;


@end

#endif /* Rend_h */
