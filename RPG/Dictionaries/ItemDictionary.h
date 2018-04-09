//
//  ItemDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef ItemDictionary_h
#define ItemDictionary_h
#import "Item.h"
#import "Firestone.h"
#import "Coldstone.h"
#import "Lightningstone.h"
#import "Poisonstone.h"
#import "Arcanestone.h"
#import "XPBoost.h"
#import "ElementScroll.h"
#import "Constants.h"
#import "MainCharacter.h"

@interface ItemDictionary : NSObject

@property NSMutableArray *itemLibrary;

+(void)loadItems;
+(Item*)generateRandomItem:(BOOL)isLoot;
+(Item*)findItem:(NSString*)s;
@end

#endif /* ItemDictionary_h */
