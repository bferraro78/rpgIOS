//
//  Dungeon.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Dungeon_h
#define Dungeon_h
#import "Space.h"
#import "MainCharacter.h"
#import "Item.h"
#import "ItemDictionary.h"
#import "InventoryManager.h"

@interface Dungeon : NSObject

@property NSMutableArray *map;
@property int dungeonLevel;
@property int size; // Based on dungeon level
@property Space *start;
@property Space *end;
@property int heroX;
@property int heroY;


-(id)initdungeonLevel:(int)aDungeonLevel heroX:(int)aHeroX heroY:(int)aHeroY;

-(int)moveHeroDirection:(NSString*)dir itemPicked:(NSMutableString*)itemPicked;
-(Space*)findLocationX:(int)x Y:(int)y Map:(NSMutableArray*)tmpMap;
-(NSMutableString*)printMap;



@end

#endif /* Dungeon_h */
