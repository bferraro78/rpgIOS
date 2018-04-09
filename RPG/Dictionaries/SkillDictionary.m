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

/** TODO --  write function that take in heroLevel/elementSpec and returns a random skill from that spec ************/

/* Load Items -- Called When Game is Started */
+(void)loadSkills {
    printf("LOADING SKILLS...\n");
    
    skillLibrary = [[NSMutableArray alloc] init];
    
    // LOAD SKILLS
    
    /** PHYSICAL **/
    [skillLibrary addObject:[[BasicAttack alloc] initmoveName:@"BasicAttack" moveDescription:@"A Basic Attack" resourceCost:8 spell:false ElementSpec:NONE]];
    
    // ROGUE
    [skillLibrary addObject:[[Vanish alloc] initmoveName:@"Vanish" moveDescription:@"Take no damage for two turns" resourceCost:25 spell:true ElementSpec:NONE]];
    [skillLibrary addObject:[[Backstab alloc] initmoveName:@"Backstab" moveDescription:@"50% crit chance increase" resourceCost:50 spell:false ElementSpec:NONE]];
    
    // BARB
    [skillLibrary addObject:[[Rend alloc] initmoveName:@"Rend" moveDescription:@"Applys a DOT" resourceCost:10 spell:false ElementSpec:NONE]];
    [skillLibrary addObject:[[Frenzy alloc] initmoveName:@"Frenzy" moveDescription:@"Chance to swing for double damage" resourceCost:25 spell:false ElementSpec:NONE]];
    
    // WIZARD
    [skillLibrary addObject:[[Heal alloc] initmoveName:@"Heal" moveDescription:@"Healing over 3 turns" resourceCost:15 spell:true ElementSpec:NONE]];
    
    /** ELEMENTAL **/
    // FIRE
    [skillLibrary addObject:[[Fireball alloc] initmoveName:@"Fireball" moveDescription:@"Huge fire damage, chance to ignite enemy for 3 turns" resourceCost:25 spell:true ElementSpec:FIRE]];
    
    // COLD
    [skillLibrary addObject:[[Freezecone alloc] initmoveName:@"Freezecone" moveDescription:@"Take 25% less damage for 3 turns" resourceCost:30 spell:true ElementSpec:COLD]];
    
    
    // LIGHTING
    
    // POISON
    
    // ARCANE


}

+(BOOL)generateDamage:(Enemy*)e heroMoveName:(NSString*)heroMoveName
        enemyMoveName:(NSString*)enemyMoveName heroElementMap:(NSMutableDictionary*)heroElementMap
     enemeyElementMap:(NSMutableDictionary*)enemeyElementMap {

    BOOL validAttack = false;
    
    /* Strips White Space -- That is how move is saved in Dictonary */
    heroMoveName = [heroMoveName stringByReplacingOccurrencesOfString:@"\\s"
                                            withString:@""
                                               options:NSRegularExpressionSearch
                                                 range:NSMakeRange(0, [heroMoveName length])];
    
    Skill *heroSkill = [self findSkill:heroMoveName];
    Skill *enemySkill = [self findSkill:enemyMoveName];
   
    int heroTotalResource = [mainCharacter getResource];
    int heroCombatResource = [mainCharacter getCombatResource];
    int combatCost = [heroSkill getCombatResourceCost:heroTotalResource];
    
    if ([self checkVaildAttack:combatCost heroCombatResource:heroCombatResource]) {
        validAttack = true;
        /* This will do all heavy work inside the Abilitie's class, and load Buff/Element Maps */
        [heroSkill activateHeroMove:heroElementMap Enemy:e];
        [enemySkill activateEnemyMove:e ElementMap:enemeyElementMap];
        [mainCharacter useCombatResource:combatCost];
    }

    return validAttack;
}

/* Check resource availability */
+(BOOL)checkVaildAttack:(int)combatCost heroCombatResource:(int)heroCombatResource {
    return (heroCombatResource >= combatCost) ? true : false;
}

+(Skill*)findSkill:(NSString*)s {
    /* Trim White Space */
    s = [s stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (int i = 0; i < [skillLibrary count]; i++) {
        Skill *tmp = [skillLibrary objectAtIndex:i];
        if ([[tmp moveName] isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end
