//
//  WeaponDIctionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeaponDictionary.h"
@implementation WeaponDictionary

NSMutableArray *weaponLibrary;

+(void)loadWeapons {
    printf("LOADING WEAPONS...\n");
    
    weaponLibrary = [[NSMutableArray alloc] init];
    
    [weaponLibrary addObject:[[Weapon alloc] initweaponID:10 weaponName:@"1000 Truths" weaponType:@"Sword" twoHand:false MH:true]];
    
    
    // LOAD WEAPONS
    
    
}

+(Weapon*)generateRandomWeapon {
    int size = (int)[weaponLibrary count];
    int choice = arc4random_uniform(size);
    
    /* Make copy of template from library */
    Weapon *tmpWeapon = [weaponLibrary objectAtIndex:choice];
    Weapon *chosenWeapon = [[Weapon alloc] initweaponID:tmpWeapon.weaponID weaponName:tmpWeapon.weaponName weaponType:tmpWeapon.weaponType twoHand:tmpWeapon.twoHand MH:tmpWeapon.isMainHand];
    
    
    /* Get Hero stats and generate Armor stats base on level */
    int heroLevel = mainCharacter.level;
    
    
    /**** TODO 
     
    - SET WEAPON ATTACK/RANGE BASED ON WEAPONTYPE BETTER
     
     *****/
    chosenWeapon.weaponRange = 10; // fix this ^^
    
    
    
    if (heroLevel < 20) {
        chosenWeapon.attack = arc4random_uniform(heroLevel+10)+heroLevel;
    } else if (heroLevel < 60) {
        chosenWeapon.attack = arc4random_uniform(heroLevel+20)+(heroLevel-10);
    } else {
        chosenWeapon.attack = arc4random_uniform(heroLevel+30)+(heroLevel-10);
    }
    
     
    /* 25% Chance item is physical damage - *80% elemental*/
    int elementalOrPhysical = arc4random_uniform(100);
    if (elementalOrPhysical < 24) {
        chosenWeapon.weaponElement = PHYSICAL;
    } else {
        int elementChoice = arc4random_uniform(4);
        if (elementChoice == 0) {
            chosenWeapon.weaponElement = FIRE;
        } else if (elementChoice == 1) {
            chosenWeapon.weaponElement = COLD;
        } else if (elementChoice == 2) {
            chosenWeapon.weaponElement = LIGHTNING;
        } else if (elementChoice == 3) {
            chosenWeapon.weaponElement = POISON;
        } else { // Arcane
            chosenWeapon.weaponElement = ARCANE;
        }
    }
    
    return chosenWeapon;
    
}

+(Weapon*)findWeapon:(NSString*)s {
    for (int i = 0; i < [weaponLibrary count]; i++) {
        Weapon *tmp = [weaponLibrary objectAtIndex:i];
        if ([tmp.weaponName isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end
