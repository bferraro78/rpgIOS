//
//  InventoryManager.h
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef InventoryManager_h
#define InventoryManager_h
#import "MainCharacter.h"
#import "Constants.h"
#import "EquipmentManager.h"

#import "Item.h"
#import "Armor.h"
#import "Weapon.h"

@interface InventoryManager : NSObject

+(void)changePurse:(int)gold;
+(void)equipOrActivateItemArmorWeapon:(NSObject*)invItem;
+(void)activateItem:(Item*)item;
+(void)removeActiveItem;
+(void)deactivateItem:(Item*)item index:(int)index;
+(void)addToInventory:(id)o;
+(void)removeFromInventory:(id)o;
+(void)receiveLoot:(NSMutableArray*)loot;


@end
#endif /* InventoryManager_h */
