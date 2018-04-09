//
//  LootManager.m
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LootManager.h"

@implementation LootManager

// 1 - 2 - 3 pieces of loot
+(NSMutableArray*)generateLoot {
    
    NSMutableArray *loot = [[NSMutableArray alloc] init];
    
    int numberOfLoots = arc4random_uniform(2)+1;
    
    for (int i = 0; i < numberOfLoots; i++) {
        int ArmorWepItemChance = arc4random_uniform(100);
        if (ArmorWepItemChance < 20) { // weapon
            [loot addObject:[WeaponDictionary generateRandomWeapon]];
        } else if (ArmorWepItemChance >= 20 && ArmorWepItemChance <= 40) { // armor
            [loot addObject:[ArmorDictionary generateRandomArmor]];
        } else { // item
            [loot addObject:[ItemDictionary generateRandomItem:true]];
        }
    }
    
    return loot;
}


@end
