//
//  SkillDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef SkillDictionary_h
#define SkillDictionary_h
#import "Skill.h"
#import "BasicAttack.h"
#import "Backstab.h"
#import "Fireball.h"
#import "Freezecone.h"
#import "Frenzy.h"
#import "Heal.h"
#import "Rend.h"
#import "Vanish.h"
@interface SkillDictionary : NSObject

@property NSMutableArray *skillLibrary;

+(void)loadSkills;
+(void)generateDamage:(Hero*)mainCharacter  Enemy:(Enemy*)e heroMoveName:(NSString*)aHeroMoveName
    enemyMoveName:(NSString*)aEnemyMoveName heroElementMap:(NSMutableDictionary*)aHeroElementMap
    enemeyElementMap:(NSMutableDictionary*)aEnemeyElementMap;
+(Skill*)findSkill:(NSString*)s;
@end

#endif /* SkillDictionary_h */
