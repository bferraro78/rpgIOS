//
//  EquipmentManager.m
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EquipmentManager.h"

@implementation EquipmentManager

/** Set Armor/Weapons **/
/* Will unequip armor if slot is not empty */
+(void)equipArmor:(Armor*)a {
    if ([a.armorType isEqualToString:@"Helmet"]) {
        [self unequipHelm];
        mainCharacter.helm = a;
    } else if ([a.armorType isEqualToString:@"Torso"]) {
        [self unequipTorso];
        mainCharacter.torso = a;
    } else if ([a.armorType isEqualToString:@"Shoulders"]) {
        [self unequipShoulders];
        mainCharacter.shoulders = a;
    } else if ([a.armorType isEqualToString:@"Bracers"]) {
        [self unequipBracers];
        mainCharacter.bracers = a;
    } else if ([a.armorType isEqualToString:@"Gloves"]) {
        [self unequipGloves];
        mainCharacter.gloves = a;
    } else if ([a.armorType isEqualToString:@"Legs"]) {
        [self unequipLegs];
        mainCharacter.legs = a;
    } else if ([a.armorType isEqualToString:@"Boots"]) {
        [self unequipBoots];
        mainCharacter.boots = a;
    } else {
        
    }
    /* Increase stats */
    [mainCharacter increaseStrn:a.armorStrn];
    [mainCharacter increaseInti:a.armorInti];
    [mainCharacter increaseDext:a.armorDext];
    [mainCharacter increaseVit:a.armorVit];
    [mainCharacter increaseResistance:a.armorElement increaseBy:a.armorResistance];
    /* Remove and reset values */
    [InventoryManager removeFromInventory:a];
    [mainCharacter resetResourceAndHealth];
}

+(void)equipWeapon:(Weapon*)w {
    if (w.isMainHand) {
        if ([self canUseWeapon:w]) {
            [self unequipMH]; // unequip current MH
            if (w.twoHand) {
                // Unquip OffHand
                [self unequipOH];
                mainCharacter.mainHand = w;
            } else {
                mainCharacter.mainHand = w;
            }
        } else {
            printf("Class can't use weapon");
        }
    } else { // OH
        if ([self canUseWeapon:w]) {
            [self unequipOH];
            mainCharacter.offHand = w;
        } else {
            printf("Class can't use weapon");
        }
    }
    [InventoryManager removeFromInventory:w];
}

+(BOOL)canUseWeapon:(Weapon*)w {
    if ([[mainCharacter getClassName] isEqualToString:@"Barb"]) {
        if (![w.weaponType isEqualToString:@"Wand"]) {
            return true;
        }
    } else if ([[mainCharacter getClassName] isEqualToString:@"Wizard"]) {
        /* WIZARDS CAN'T DUAL WIELD */
        if (w.isMainHand) { // MH
            if ([w.weaponType isEqualToString:@"Wand"] || [w.weaponType isEqualToString:@"Staff"] ||
                [w.weaponType isEqualToString:@"Sword"] || [w.weaponType isEqualToString:@"Dagger"] ||
                [w.weaponType isEqualToString:@"Shield"]) {
                return true;
            }
        } else { // OH
            if ([w.weaponType isEqualToString:@"Shield"]) {
                return true;
            } else {
                printf("Class Can't Dual Wield");
            }
        }
    } else { // Rogue
        if ([w.weaponType isEqualToString:@"Blunt"] || [w.weaponType isEqualToString:@"Axe"] ||
            [w.weaponType isEqualToString:@"Sword"] || [w.weaponType isEqualToString:@"Dagger"]) {
            return true;
        }
    }
    
    return false;
    
}

/** Unequip Items **/
/* Removes any:
 * Stat boosts, Resistance Boosts, resets health/resource,
 * Add to Inventory, Make slot nil */
+(void)unequipHelm {
    if (mainCharacter.helm != nil) {
        [mainCharacter decreaseStrn:mainCharacter.helm.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.helm.armorInti];
        [mainCharacter decreaseDext:mainCharacter.helm.armorDext];
        [mainCharacter decreaseVit:mainCharacter.helm.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.helm.armorElement decreaseBy:mainCharacter.helm.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.helm];
        mainCharacter.helm = nil;
    }
}

+(void)unequipShoulders {
    if (mainCharacter.shoulders != nil) {
        [mainCharacter decreaseStrn:mainCharacter.shoulders.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.shoulders.armorInti];
        [mainCharacter decreaseDext:mainCharacter.shoulders.armorDext];
        [mainCharacter decreaseVit:mainCharacter.shoulders.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.shoulders.armorElement decreaseBy:mainCharacter.shoulders.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.shoulders];
        mainCharacter.shoulders = nil;
    }
}

+(void)unequipBracers {
    if (mainCharacter.bracers != nil) {
        [mainCharacter decreaseStrn:mainCharacter.bracers.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.bracers.armorInti];
        [mainCharacter decreaseDext:mainCharacter.bracers.armorDext];
        [mainCharacter decreaseVit:mainCharacter.bracers.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.bracers.armorElement decreaseBy:mainCharacter.bracers.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.bracers];
        mainCharacter.bracers = nil;
    }
}

+(void)unequipGloves {
    if (mainCharacter.gloves != nil) {
        [mainCharacter decreaseStrn:mainCharacter.gloves.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.gloves.armorInti];
        [mainCharacter decreaseDext:mainCharacter.gloves.armorDext];
        [mainCharacter decreaseVit:mainCharacter.gloves.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.gloves.armorElement decreaseBy:mainCharacter.gloves.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.gloves];
        mainCharacter.gloves = nil;
    }
}

+(void)unequipTorso {
    if (mainCharacter.torso != nil) {
        [mainCharacter decreaseStrn:mainCharacter.torso.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.torso.armorInti];
        [mainCharacter decreaseDext:mainCharacter.torso.armorDext];
        [mainCharacter decreaseVit:mainCharacter.torso.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.torso.armorElement decreaseBy:mainCharacter.torso.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.torso];
        mainCharacter.torso = nil;
    }
}

+(void)unequipLegs {
    if (mainCharacter.legs != nil) {
        [mainCharacter decreaseStrn:mainCharacter.legs.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.legs.armorInti];
        [mainCharacter decreaseDext:mainCharacter.legs.armorDext];
        [mainCharacter decreaseVit:mainCharacter.legs.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.legs.armorElement decreaseBy:mainCharacter.legs.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.legs];
        mainCharacter.legs = nil;
    }
}

+(void)unequipBoots {
    if (mainCharacter.boots != nil) {
        [mainCharacter decreaseStrn:mainCharacter.boots.armorStrn];
        [mainCharacter decreaseInti:mainCharacter.boots.armorInti];
        [mainCharacter decreaseDext:mainCharacter.boots.armorDext];
        [mainCharacter decreaseVit:mainCharacter.boots.armorVit];
        [mainCharacter decreaseResistance:mainCharacter.boots.armorElement decreaseBy:mainCharacter.boots.armorResistance];
        [mainCharacter resetResourceAndHealth];
        [InventoryManager addToInventory:mainCharacter.boots];
        mainCharacter.boots = nil;
    }
}

+(void)unequipMH {
    if (mainCharacter.mainHand != nil) {
        [InventoryManager addToInventory:mainCharacter.mainHand];
        mainCharacter.mainHand = nil;
    }
}

+(void)unequipOH {
    if (mainCharacter.offHand != nil) {
        [InventoryManager addToInventory:mainCharacter.offHand];
        mainCharacter.offHand = nil;
    }
}


@end
