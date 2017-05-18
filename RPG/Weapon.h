//
//  Weapon.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Weapon_h
#define Weapon_h
@interface Weapon : NSObject

@property int weaponID;
@property int attack;
@property NSString *weaponType;
@property NSString *weaponName;
@property int weaponRange;
@property NSString *weaponElement;


-(id)initweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType;



@end
#endif /* Weapon_h */
