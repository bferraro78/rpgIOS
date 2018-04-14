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
int weaponRange;
NSString *weaponElement;
NSString *weaponType;
NSString *weaponName;
BOOL twoHand;
BOOL isMainHand;


-(id)initweaponID:(int)aID weaponName:(NSString*)aName weaponType:(NSString*)aType twoHand:(BOOL)aTwoHand MH:(BOOL)aIsMainHand {
    _weaponID = aID;
    _weaponName = aName;
    _weaponType = aType;
    _twoHand = aTwoHand;
    _isMainHand = aIsMainHand;
    
    /* THESE ARE SET FOR WHEN THE Weapon SLOT ON HERO IS NIL
     * Used when getMH/OH is called and no armor in that slot
     * is equipped (ex. most ability classes) */
    _attack =  0;
    _weaponRange = 0;
    _weaponElement = PHYSICAL;

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
    
    [wepPrint appendFormat:@"\n    Name: %s\n    Attack: %s - %s\n    Element: %s" , [_weaponName UTF8String], [lowRangeStr UTF8String], [highRangeStr UTF8String], [_weaponElement UTF8String]];
    
    return wepPrint;
}

-(NSString*)getName { return self.weaponName; }

@end
