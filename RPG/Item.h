//
//  Item.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Item_h
#define Item_h
#import "Hero.h"
@class Item;
@interface Item : NSObject

@property NSString *itemDescription;

/* Methods */
-(id)inititemDescription:(NSString*)aDescription;
-(NSString*)toString;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;
/* Add or take away any buffs from an item (Such as a resistance from a stone */
-(void)activateItem:(Hero*)mainCharacter;
-(void)deactivateItem:(Hero*)mainCharacter;
@end

#endif /* Item_h */
