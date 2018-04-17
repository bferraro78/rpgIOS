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
    
    buffLib = [[NSMutableDictionary alloc] init]; // descriptions
    buffLibToName = [[NSMutableDictionary alloc] init]; // UI Names
    
    [buffLib setObject:@"Frozen: Take 25% Less Damage" forKey:FROZEN];
    [buffLibToName setObject:FROZEN forKey:FROZEN];
    
    [buffLib setObject:@"Burning: Take Dot Damage" forKey:FIREDOT];
    [buffLibToName setObject:BURNING forKey:FIREDOT];
    
    [buffLib setObject:@"Heal: Heals Over Time" forKey:HEALDOT];
    [buffLibToName setObject:HEAL forKey:HEALDOT];
    
    [buffLib setObject:@"Rend: Enemey Gushing Blood" forKey:RENDDOT];
    [buffLibToName setObject:REND forKey:RENDDOT];
    
    [buffLib setObject:@"Vanish: Cannot Find You..." forKey:VANISH];
    [buffLibToName setObject:VANISH forKey:VANISH];

    [buffLib setObject:POISONPASSIVEDOT forKey:POISONPASSIVEDOT];
    [buffLibToName setObject:POISONPASSIVEDOT forKey:POISONPASSIVEDOT];    
}

+(NSString*)getDescription:(NSString*)s {
    NSString *str = buffLib[s];
    return str;

}

// hero/enemy buff/debufffLibrary name (rendDot, healDot) --> Name printed on UI
+(NSString*)getName:(NSString*)s {
    NSString *str = buffLibToName[s];
    return str;
}

@end
