//
//  BasicAttack.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef BasicAttack_h
#define BasicAttack_h

#import "Enemy.h"
#import "Skill.h"

@interface BasicAttack : Skill

@property int basicattackResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;


-(int)getCombatResourceCost:(int)totalResource;
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;


@end

#endif /* BasicAttack_h */
