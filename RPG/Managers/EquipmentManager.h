//
//  EquipmentManager.h
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EquipmentManager_h
#define EquipmentManager_h
#import "MainCharacter.h"
#import "InventoryManager.h"
#import "Armor.h"
#import "Weapon.h"

@interface EquipmentManager : NSObject

+(void)equipArmor:(Armor*)a;
+(void)equipWeapon:(Weapon*)w;
+(BOOL)canUseWeapon:(Weapon*)w;

+(void)unequipHelm;
+(void)unequipShoulders;
+(void)unequipBracers;
+(void)unequipGloves;
+(void)unequipTorso;
+(void)unequipLegs;
+(void)unequipBoots;
+(void)unequipMH;
+(void)unequipOH;

@end

#endif /* EquipmentManager_h */
