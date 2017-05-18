//
//  main.m
//  RPG
//
//  Created by Ben Ferraro on 5/13/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Hero.h"
#import "Barbarian.h"
#import "Wizard.h"
#import "Rogue.h"
#import "Dungeon.h"
#import "Space.h"
#import "Combat.h"


int main(int argc, char * argv[]) {
    
    /** LOAD DICTIONARIES **/
    [ItemDictionary loadItems];
    [SkillDictionary loadSkills];
    [EnemyDictionary loadEnemies];
    
    
    Hero *herooo = [[Hero alloc] initname:@"BEANOO!" classID:1 vit:40 strn:20 inti:10 dext:10 startX:0 startY:0 dungeonLvl:0];
    Barbarian *barb = [[Barbarian alloc] initname:@"OO!!" classID:1 vit:40 strn:20 inti:10 dext:10 startX:0 startY:0 dungeonLvl:1];

    Wizard *zard = [[Wizard alloc] initname:@"WAZARRDDD" classID:1 vit:40 strn:10 inti:20 dext:10 startX:0 startY:0 dungeonLvl:1];
    
    
    NSString *resourceName = [barb getResourceName];
    printf("\n%s", [resourceName UTF8String]);
    printf("\n%s", [[barb getClassName] UTF8String]);
    printf("\nBARB Rage number: %u\n", barb.rage);
    printf("Hero STRENGTH number: %u\n", herooo.strn);
    
    
    Dungeon *map = [[Dungeon alloc] initdungeonLevel:1 heroX:0 heroY:0];
    [map printMap];
    
    [map moveHeroDirection:@"down" Hero:barb];
    [map printMap];
    
    printf("ZARD SKILL at 0 %s\n", [[zard.skillSet objectAtIndex:0] UTF8String]);
    
    [Combat initCombat:barb];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
