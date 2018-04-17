//
//  Weapon.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Weapon_h
#define Weapon_h
#import "Constants.h"

@interface Weapon : NSObject

@property int weaponID;
@property int attack;
@property int weaponVit;
@property int weaponStrn;
@property int weaponDext;
@property int weaponInti;
@property NSString *weaponType;
@property NSString *weaponName;
@property int weaponRange;
@property NSString *weaponElement;
@property BOOL twoHand;
@property BOOL isMainHand;


-(id)initForRandomStatsweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType twoHand:(BOOL)aTwoHand
                             MH:(BOOL)aIsMainHand;

-(id)initWeaponFromDictionaryweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType weaponVit:(int)aWeaponVit weaponStrn:(int)aWeaponStrn weaponDext:(int)aWeaponDext weaponInti:(int)aWeaponInti aAttack:(int)aAttack aWeaponRange:(int)aWeaponRange
                       aWeaponElement:(NSString*)aWeaponElement twoHand:(BOOL)aTwoHand MH:(BOOL)aIsMainHand;

-(int)getSwing;
-(NSMutableString*)toString;

-(NSMutableDictionary*)weaponToDictionary;
+(Weapon*)createWeaponFromDictionary:(NSMutableDictionary*)weaponDictionary;

@end
#endif /* Weapon_h */
