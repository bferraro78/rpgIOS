//
//  LootManager.h
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef LootManager_h
#define LootManager_h
#import "ItemDictionary.h"
#import "ArmorDictionary.h"
#import "WeaponDictionary.h"
#import "MainCharacter.h"

@interface LootManager : NSObject

+(NSMutableArray*)generateLoot;

@end

#endif /* LootManager_h */
