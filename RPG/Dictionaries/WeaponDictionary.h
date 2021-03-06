//
//  WeaponDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef WeaponDictionary_h
#define WeaponDictionary_h
#import "MainCharacter.h"
#import "Constants.h"

@interface WeaponDictionary : NSObject

@property NSMutableArray *weaponLibrary;

+(void)loadWeapons;
+(Weapon*)generateRandomWeapon;
+(Weapon*)findWeapon:(NSString*)s;
@end

#endif /* WeaponDictionary_h */
