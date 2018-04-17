//
//  Skill.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Skill_h
#define Skill_h
#import <Foundation/Foundation.h>

#import "MainCharacter.h"
#import "Enemy.h"

@interface Skill : NSObject

@property NSString *moveName;
@property BOOL spell;
@property NSString *skillElementSpec;

-(id)initmoveName:(NSString*)aMoveName spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec;

-(int)getCombatResourceCost:(int)totalResource;
-(NSString*)getMoveDescription;
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e;
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap;

@end

#endif /* Skill_h */
