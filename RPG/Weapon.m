//
//  Weapon.m
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
@implementation Weapon

int weaponID;
int attack;
NSString *weaponElement;
NSString *weaponType;
NSString *weaponName;



-(id)initweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType {
    _weaponID = aID;
    _weaponName = aName;
    _weaponType = aType;
    
    /* THESE ARE SET FOR WHEN THE ARMOR SLOT ON HERO IS NIL
     * Used when getMH/OH is called and no armor in that slot
     * is equipped (ex. most ability classes) */
    _attack =  0;
    _weaponElement = @"PHYSICAL";
    return self;
}


//public String toString() {
//    if (getAttack() == 0)
//        return "";
//    return name + " | Attack: " + attack + " | Element: " + element; }

@end