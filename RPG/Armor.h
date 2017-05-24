//
//  Armor.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Armor_h
#define Armor_h
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


-(id)initarmorID:(int)aID  armorName:(NSString*)aName armorType:(NSString*)aType;
-(NSMutableString*)toString;



@end

#endif /* Armor_h */
