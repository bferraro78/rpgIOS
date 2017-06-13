//
//  Skill.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Skill_h
#define Skill_h
#import "Hero.h"
#import "Enemy.h"
@interface Skill : NSObject

@property NSString *moveName;
@property NSString *moveDescription;
@property BOOL spell;
@property NSString *skillElementSpec;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;

-(int)getCombatResourceCost:(int)totalResource;
-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter;

@end

#endif /* Skill_h */
