//
//  Armor.m
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Armor.h"

@implementation Armor

int armorID;
int armor;
NSString *armorType;
NSString *armorName;
int armorVit;
int armorStrn;
int armorDext;
int armorInti;
NSString *armorElement;
int armorResistance;

-(id)initarmorID:(int)aID  armorName:(NSString*)aName armorType:(NSString*)aType {
    _armorID = aID;
    _armorName = aName;
    _armorType = aType;
    
    /* THESE ARE SET FOR WHEN THE ARMOR SLOT ON HERO IS NIL--
     * Used when getArmor is called and no armor in that slot
     * is equipped.*/
    _armor = 0;
    _armorVit = 0;
    _armorStrn = 0;
    _armorDext = 0;
    _armorInti = 0;
    _armorElement = PHYSICAL;
    _armorResistance = 0;
    
    return self;
}

-(NSMutableString*)toString {
    NSMutableString *armorPrint = [[NSMutableString alloc] init];
    
    [armorPrint appendFormat:@"\n    Name: %s\n    Armor: %u\n    Strn: %u\n    Inti: %u\n    Dext: %u\n    Vit: %u\n    Element: %s +%u",
     [_armorName UTF8String], _armor, _armorStrn, _armorInti, _armorDext, _armorVit, [_armorElement UTF8String], _armorResistance];
    
    return armorPrint;
}

-(NSString*)getName { return self.armorName; }


@end
