//
//  BuffDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/18/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuffDictionary.h"
@implementation BuffDictionary

NSMutableDictionary *buffLib;


+(void)loadBuffLibrary {
    printf("Load Buffs");
    
    buffLib = [[NSMutableDictionary alloc] init];
    
    [buffLib setObject:@"frozen" forKey:@"Frozen: Take 25% Less Damage " ];
    [buffLib setObject:@"fireDot" forKey:@"Burning: Take Dot Damage "];
    [buffLib setObject:@"healDot" forKey:@"Heal: Heals Over Time "];
    [buffLib setObject:@"rendDot" forKey:@"Rend: Enemey Gushing Blood "];
    [buffLib setObject:@"vanish" forKey:@"Vanish: Cannot Find You... " ];

    [buffLib setObject:@"poisonPassiveDot" forKey:@"Poison Passive Dot "];
}

+(NSString*)getDescription:(NSString*)s {
    return [buffLib objectForKey:s];
}

@end