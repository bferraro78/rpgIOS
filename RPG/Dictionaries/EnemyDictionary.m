//
//  EnemyDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyDictionary.h"
@implementation EnemyDictionary

NSMutableArray *enemyLibrary;

+(void)loadEnemies {
    printf("LOADING ENEMIES...\n");
    enemyLibrary = [[NSMutableArray alloc] init];
    
    // LOAD ENEMIES
    [enemyLibrary addObject:[[Enemy alloc] initenemyName:@"MURLOC DUUDE" enemyElement:PHYSICAL
                                           enemySkillSet:[[NSMutableArray alloc] initWithObjects:BASICATTACK, FIREBALL, nil] enemyStrn:10 enemyInti:10 enemyDext:10 enemyHealth:100 enemyArmor:100]];
    
    
}

+(Enemy*)generateRandomEnemy {
    int size = (int)[enemyLibrary count];
    int choice = arc4random_uniform(size);
    
    /* Make copy of template from library */
    Enemy *tmpEnemy = [enemyLibrary objectAtIndex:choice];
    Enemy *chosenEnemy = [[Enemy alloc] initenemyName:tmpEnemy.name enemyElement:tmpEnemy.elementSpec enemySkillSet:tmpEnemy.enemySkillSet enemyStrn:tmpEnemy.strn enemyInti:tmpEnemy.inti enemyDext:tmpEnemy.dext enemyHealth:tmpEnemy.health enemyArmor:tmpEnemy.enemyArmor];

    /* Generate Random Enemy */
    int heroPrimaryStat = [mainCharacter getPrimaryStat];
    int heroLevel = mainCharacter.level;
    int heroArmor = [mainCharacter getTotalArmor];
    int heroHeatlh = mainCharacter.health;
    
    chosenEnemy.strn = arc4random_uniform(heroPrimaryStat/2)+heroLevel;
    chosenEnemy.inti = arc4random_uniform(heroPrimaryStat/2)+heroLevel;
    chosenEnemy.dext = arc4random_uniform(heroPrimaryStat/2)+heroLevel;
    chosenEnemy.health = ((arc4random_uniform(heroHeatlh)+(heroLevel))+20);
    chosenEnemy.combatHealth = chosenEnemy.health;
    chosenEnemy.enemyArmor = arc4random_uniform(heroArmor)+heroLevel;
    
    [chosenEnemy setExp];
    
    return chosenEnemy;
}

+(Enemy*)findEnemy:(NSString*)s {
    for (int i = 0; i < [enemyLibrary count]; i++) {
        Enemy *tmp = [enemyLibrary objectAtIndex:i];
        if ([tmp.name isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end
