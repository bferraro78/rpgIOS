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

-(id)initForRandomStatsarmorID:(int)aID armorName:(NSString*)aName armorType:(NSString*)aType {
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

-(id)initArmorFromDictionaryarmorID:(int)aID armorName:(NSString*)aName armorType:(NSString*)aType aArmor:(int)aArmor aArmorVit:(int)aArmorVit
                         aArmorStrn:(int)aArmorStrn aArmorDext:(int)aArmorDext aArmorInti:(int)aArmorInti
                           aElement:(NSString*)aElement aArmorResistance:(int)aArmorResistance {
    _armorID = aID;
    _armorName = aName;
    _armorType = aType;
    
    _armor = aArmor;
    _armorVit = aArmorVit;
    _armorStrn = aArmorStrn;
    _armorDext = aArmorDext;
    _armorInti = aArmorInti;
    
    _armorElement = aElement;
    _armorResistance = aArmorResistance;
    
    return self;
}

-(NSMutableString*)toString {
    NSMutableString *armorPrint = [[NSMutableString alloc] init];
    
    [armorPrint appendFormat:@"\n    Name: %s\n    Armor: %u\n    Strn: %u\n    Inti: %u\n    Dext: %u\n    Vit: %u\n    Element: %s +%u",
     [_armorName UTF8String], _armor, _armorStrn, _armorInti, _armorDext, _armorVit, [_armorElement UTF8String], _armorResistance];
    
    return armorPrint;
}

-(NSString*)getName { return self.armorName; }

-(NSMutableDictionary*)armorToDictionary {
    NSMutableDictionary *armorDictionary = [[NSMutableDictionary alloc] init];
    
    armorDictionary[@"armorID"] = [NSString stringWithFormat:@"%i", _armorID];
    armorDictionary[@"armor"] = [NSString stringWithFormat:@"%i", _armor];
    
    armorDictionary[@"armorVit"] = [NSString stringWithFormat:@"%i", _armorVit];
    armorDictionary[@"armorStrn"] = [NSString stringWithFormat:@"%i", _armorStrn];
    armorDictionary[@"armorDext"] = [NSString stringWithFormat:@"%i", _armorDext];
    armorDictionary[@"armorInti"] = [NSString stringWithFormat:@"%i", _armorInti];
    
    armorDictionary[@"armorType"] = _armorType;
    armorDictionary[@"armorName"] = _armorName;
    
    armorDictionary[@"armorElement"] = _armorElement;
    armorDictionary[@"armorResistance"] = [NSString stringWithFormat:@"%i", _armorResistance];
    
    return armorDictionary;
}

+(Armor*)createArmorFromDictionary:(NSMutableDictionary*)armorDictionary {
    Armor *returnArmor;
    
    if ([armorDictionary[@"armorID"] intValue] == 0) { // empty slot!
        returnArmor = [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        returnArmor = [[Armor alloc] initArmorFromDictionaryarmorID:[armorDictionary[@"armorID"] intValue] armorName:armorDictionary[@"armorName"] armorType:armorDictionary[@"armorType"] aArmor:[armorDictionary[@"armor"] intValue] aArmorVit:[armorDictionary[@"armorVit"] intValue] aArmorStrn:[armorDictionary[@"armorStrn"] intValue] aArmorDext:[armorDictionary[@"armorDext"] intValue] aArmorInti:[armorDictionary[@"armorInti"] intValue] aElement:armorDictionary[@"armorElement"] aArmorResistance:[armorDictionary[@"armorResistance"] intValue]];
    }
    return returnArmor;
}

@end
