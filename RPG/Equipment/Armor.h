//
//  Armor.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Armor_h
#define Armor_h
#import "Constants.h"

@interface Armor : NSObject

@property int armorID;
@property int armor;
@property NSString *armorType;
@property NSString *armorName;
@property int armorVit;
@property int armorStrn;
@property int armorDext;
@property int armorInti;
@property NSString *armorElement;
@property int armorResistance;


-(id)initForRandomStatsarmorID:(int)aID  armorName:(NSString*)aName armorType:(NSString*)aType;
-(id)initArmorFromDictionaryarmorID:(int)aID armorName:(NSString*)aName armorType:(NSString*)aType aArmor:(int)aArmor aArmorVit:(int)aArmorVit
                         aArmorStrn:(int)aArmorStrn aArmorDext:(int)aArmorDext aArmorInti:(int)aArmorInti
                           aElement:(NSString*)aElement aArmorResistance:(int)aArmorResistance;

-(NSMutableString*)toString;
-(NSString*)getName;

-(NSMutableDictionary*)armorToDictionary;
+(Armor*)createArmorFromDictionary:(NSMutableDictionary*)armorDictionary;

@end

#endif /* Armor_h */
