//
//  SkillDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillDictionary.h"
@implementation SkillDictionary

NSMutableArray *skillLibrary;


/* Load Items -- Called When Game is Started */
+(void)loadSkills {
    printf("LOADING SKILLS...\n");
    
    skillLibrary = [[NSMutableArray alloc] init];
    
    // LOAD SKILLS
    
    [skillLibrary addObject:[[BasicAttack alloc] initmoveName:@"BasicAttack" moveDescription:@"A Basic Attack" resourceCost:8 spell:false ElementSpec:@"NONE"]];
    [skillLibrary addObject:[[Fireball alloc] initmoveName:@"Fireball" moveDescription:@"Huge fire damage, chance to ignite enemy for 3 turns" resourceCost:25 spell:true ElementSpec:@"FIRE"]];
    [skillLibrary addObject:[[Vanish alloc] initmoveName:@"Vanish" moveDescription:@"Take no damage for two turns" resourceCost:25 spell:true ElementSpec:@"NONE"]];
    [skillLibrary addObject:[[Backstab alloc] initmoveName:@"Backstab" moveDescription:@"50% crit chance increase" resourceCost:50 spell:false ElementSpec:@"NONE"]];
    [skillLibrary addObject:[[Freezecone alloc] initmoveName:@"Freezecone" moveDescription:@"Take 25% less damage for 3 turns" resourceCost:30 spell:true ElementSpec:@"COLD"]];
    [skillLibrary addObject:[[Rend alloc] initmoveName:@"Rend" moveDescription:@"Applys a DOT" resourceCost:10 spell:false ElementSpec:@"NONE"]];
    [skillLibrary addObject:[[Frenzy alloc] initmoveName:@"Frenzy" moveDescription:@"Chance to swing for double damage" resourceCost:25 spell:false ElementSpec:@"NONE"]];
    [skillLibrary addObject:[[Heal alloc] initmoveName:@"Heal" moveDescription:@"Healing over 3 turns" resourceCost:15 spell:true ElementSpec:@"NONE"]];
    
}

+(void)generateDamage:(Hero*)mainCharacter  Enemy:(Enemy*)e heroMoveName:(NSString*)heroMoveName
        enemyMoveName:(NSString*)enemyMoveName heroElementMap:(NSMutableDictionary*)heroElementMap
     enemeyElementMap:(NSMutableDictionary*)enemeyElementMap {

    Skill *heroSkill = [self findSkill:heroMoveName];
    Skill *enemySkill = [self findSkill:enemyMoveName];
    
//    printf("Selected Hero Skill: %s\n", [[heroSkill moveName] UTF8String]);
//    printf("Selected Enemy Skill: %s\n", [[enemySkill moveName] UTF8String]);
   
    /* This will do all heavy work inside the Abilitie's class, and load Buff/Element Maps */
    [heroSkill activateHeroMove:mainCharacter ElementMap:heroElementMap];
    [enemySkill activateEnemyMove:e ElementMap:enemeyElementMap Hero:mainCharacter];
    
    
}


+(Skill*)findSkill:(NSString*)s {
    for (int i = 0; i < [skillLibrary count]; i++) {
        Skill *tmp = [skillLibrary objectAtIndex:i];

        if ([[tmp moveName] isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end