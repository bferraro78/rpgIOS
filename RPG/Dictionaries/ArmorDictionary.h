//
//  ArmorDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef ArmorDictionary_h
#define ArmorDictionary_h
#import "MainCharacter.h"
#import "Constants.h"

@interface ArmorDictionary : NSObject

@property NSMutableArray *armorLibrary;

+(void)loadArmor;
+(Armor*)generateRandomArmor;
+(Armor*)findArmor:(NSString*)s;
@end

#endif /* ArmorDictionary_h */
