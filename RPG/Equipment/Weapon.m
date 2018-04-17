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
/* 2H Types are MH type */
/** WEAPON TYPES: SWORD/2H, AXE/2H, BLUNT/2H, SHIELD(OH), DAGGER, WAND(MH), STAFF(2H), POLEARM(2H)  **/ 
int weaponID;
int attack;
int weaponVit;
int weaponStrn;
int weaponDext;
int weaponInti;
int weaponRange;
NSString *weaponElement;
NSString *weaponType;
NSString *weaponName;
BOOL twoHand;
BOOL isMainHand;


-(id)initForRandomStatsweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType twoHand:(BOOL)aTwoHand
                                   MH:(BOOL)aIsMainHand {
    _weaponID = aID;
    _weaponName = aName;
    _weaponType = aType;
    _twoHand = aTwoHand;
    _isMainHand = aIsMainHand;
    
    /* THESE ARE SET FOR WHEN THE Weapon SLOT ON HERO IS NIL
     * Used when getMH/OH is called and no armor in that slot
     * is equipped (ex. most ability classes) */
    _weaponVit = 0;
    _weaponStrn = 0;
    _weaponDext = 0;
    _weaponInti = 0;
    _attack =  0;
    _weaponRange = 0;
    _weaponElement = PHYSICAL;
    
    return self;
}

-(id)initWeaponFromDictionaryweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType weaponVit:(int)aWeaponVit weaponStrn:(int)aWeaponStrn weaponDext:(int)aWeaponDext weaponInti:(int)aWeaponInti aAttack:(int)aAttack aWeaponRange:(int)aWeaponRange
                 aWeaponElement:(NSString*)aWeaponElement twoHand:(BOOL)aTwoHand MH:(BOOL)aIsMainHand {
    
    _weaponID = aID;
    _weaponName = aName;
    _weaponType = aType;
    _weaponVit = aWeaponVit;
    _weaponStrn = aWeaponStrn;
    _weaponDext = aWeaponDext;
    _weaponInti = aWeaponInti;
    
    _twoHand = aTwoHand;
    _isMainHand = aIsMainHand;
    
    _attack = aAttack;
    _weaponRange = aWeaponRange;
    _weaponElement = aWeaponElement;


    return self;
}

-(int)getSwing {
    int weaponRangeLower = self.attack-self.weaponRange;
    if (weaponRangeLower < 0) {
        weaponRangeLower = 0;
    }
    int weaponRangeUpper = self.attack+self.weaponRange;
    int swing = arc4random_uniform(weaponRangeUpper)+weaponRangeLower;
    
    return swing;
}

-(NSMutableString*)toString {
    NSMutableString *wepPrint = [[NSMutableString alloc] init];
    
    int lowRange = _attack-_weaponRange;
    if (lowRange < 0) {
        lowRange = 0;
    }
    
    NSString *lowRangeStr = [NSString stringWithFormat:@"%i", lowRange];
    NSString *highRangeStr = [NSString stringWithFormat:@"%i", _attack+_weaponRange];
    NSString *twoHand = (_twoHand) ? @"Two-Hand" : @"OneHand";
    if ([twoHand isEqualToString:@"OneHand"]) {
        twoHand = (_isMainHand) ? @"Main Hand" : @"Off Hand";
    }
    
    [wepPrint appendFormat:@"%s\n    Name: %s\n    Attack: %s - %s\n    Element: %s\n    Strn: %i\n    Inti: %i\n    Dext: %i\n    Vit: %i\n",
     [twoHand UTF8String], [_weaponName UTF8String], [lowRangeStr UTF8String], [highRangeStr UTF8String], [_weaponElement UTF8String], _weaponVit, _weaponStrn, _weaponDext, _weaponInti];
    
    return wepPrint;
}

-(NSString*)getName { return self.weaponName; }

-(NSMutableDictionary*)weaponToDictionary {
    NSMutableDictionary *weaponDictionary = [[NSMutableDictionary alloc] init];
    
    weaponDictionary[@"weaponID"] = [NSString stringWithFormat:@"%i", _weaponID];
    weaponDictionary[@"attack"] = [NSString stringWithFormat:@"%i", _attack];
    weaponDictionary[@"weaponVit"] = [NSString stringWithFormat:@"%i", _weaponVit];
    weaponDictionary[@"weaponStrn"] = [NSString stringWithFormat:@"%i", _weaponStrn];
    weaponDictionary[@"weaponDext"] = [NSString stringWithFormat:@"%i", _weaponDext];
    weaponDictionary[@"weaponInti"] = [NSString stringWithFormat:@"%i", _weaponInti];
    weaponDictionary[@"weaponType"] = _weaponType;
    weaponDictionary[@"weaponName"] = _weaponName;
    weaponDictionary[@"weaponRange"] = [NSString stringWithFormat:@"%i", _weaponRange];
    weaponDictionary[@"weaponElement"] = _weaponElement;
    weaponDictionary[@"twoHand"] =  (_twoHand) ? @"true" : @"false";
    weaponDictionary[@"isMainHand"] = (_isMainHand) ? @"true" : @"false";
    
    return weaponDictionary;
}

+(Weapon*)createWeaponFromDictionary:(NSMutableDictionary*)weaponDictionary {
    Weapon *returnWeapon;
    
    if ([weaponDictionary[@"weaponID"] intValue] == 0) { // empty slot!
        returnWeapon = [[Weapon alloc] initForRandomStatsweaponID:0 weaponName:@"" weaponType:@"" twoHand:false MH:false];
    } else {
    
        returnWeapon = [[Weapon alloc] initWeaponFromDictionaryweaponID:[weaponDictionary[@"weaponID"] intValue]
                                                              weaponName:weaponDictionary[@"weaponName"]
                                                              weaponType:weaponDictionary[@"weaponType"]
                                                               weaponVit:[weaponDictionary[@"weaponVit"] intValue]
                                                              weaponStrn:[weaponDictionary[@"weaponStrn"] intValue]
                                                              weaponDext:[weaponDictionary[@"weaponDext"] intValue]
                                                              weaponInti:[weaponDictionary[@"weaponInti"] intValue]
                                                                 aAttack:[weaponDictionary[@"attack"] intValue]
                                                            aWeaponRange:[weaponDictionary[@"weaponRange"] intValue]
                                                          aWeaponElement:weaponDictionary[@"weaponElement"]
                                                                twoHand:([weaponDictionary[@"twoHand"] isEqualToString:@"true"] ) ? true : false
                                                                     MH:([weaponDictionary[@"isMainHand"] isEqualToString:@"true"] ) ? true : false];

    }
    return returnWeapon;
    
}

@end
