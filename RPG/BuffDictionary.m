//
//  BuffDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/18/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuffDictionary.h"

/**
 -Hero buff map holds hero buffs (healing)
 -Hero debuff map hold damage buffs casted by enemy (enemy uses rend)
 
 -Enemy buff hold enemy buffs
 -Enemy debuff map hold debuffs casted by hero
**/


@implementation BuffDictionary

NSMutableDictionary *buffLib;
NSMutableDictionary *buffLibToName;


+(void)loadBuffLibrary {
    printf("LOADING BUFFS...");
    
    buffLib = [[NSMutableDictionary alloc] init];
    buffLibToName = [[NSMutableDictionary alloc] init];
    
    [buffLib setObject:@"Frozen: Take 25% Less Damage" forKey:@"frozen" ];
    [buffLibToName setObject:@"Frozen" forKey:@"frozen" ];
    
    [buffLib setObject:@"Burning: Take Dot Damage" forKey:@"fireDot"];
    [buffLibToName setObject:@"Burning" forKey:@"fireDot"];
    
    [buffLib setObject:@"Heal: Heals Over Time" forKey:@"healDot"];
    [buffLibToName setObject:@"Healing" forKey:@"healDot"];
    
    [buffLib setObject:@"Rend: Enemey Gushing Blood" forKey:@"rendDot"];
    [buffLibToName setObject:@"Rend" forKey:@"rendDot"];
    
    
    [buffLib setObject:@"Vanish: Cannot Find You..." forKey:@"vanish" ];
    [buffLibToName setObject:@"Vanish" forKey:@"vanish" ];

    [buffLib setObject:@"Poison Passive Dot" forKey:@"poisonPassiveDot"];
    [buffLibToName setObject:@"Poison Passive" forKey:@"poisonPassiveDot"];
    
}

+(NSString*)getDescription:(NSString*)s {
    NSString *str = buffLib[s];
    return str;

}

+(NSString*)getName:(NSString*)s {
    NSString *str = buffLibToName[s];
    return str;
}

@end