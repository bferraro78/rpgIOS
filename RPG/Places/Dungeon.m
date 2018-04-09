//
//  Dungeon.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dungeon.h"
/** Spaces of Map: 
 (0,0) - Start
 (1,1,) - Path
 (2,2) - End
 (3,3) - Invalid Path (Fight Monster)
 (4,4) - Hero Location **/
@implementation Dungeon


int ITEMGENERATEPERCENT = 10;

int dungeonLevel;
int size; // Based on dungeon level
Space *start;
Space *end;
int heroX;
int heroY;
NSMutableArray *map;

-(id)initdungeonLevel:(int)aDungeonLevel heroX:(int)aHeroX heroY:(int)aHeroY {
    _dungeonLevel = aDungeonLevel;
    _size = self.dungeonLevel+10;
    _heroX = aHeroX;
    _heroY = aHeroY;
    _start = [[Space alloc] initx:0 y:0 item:nil];
    _map = [self generateMap];
    
    // Init Hero location
    [[_map objectAtIndex:self.heroX] replaceObjectAtIndex:self.heroY withObject: [[Space alloc] initx:4 y:4 item:nil]];

    return self;
}

-(int)moveHeroDirection:(NSString*)dir itemPicked:(NSMutableString*)itemPicked {
    int newX = self.heroX;
    int newY = self.heroY;
    int code;
    
    if ([dir isEqualToString:@"up"]) {
        newX--;
    } else if ([dir isEqualToString:@"left"]) {
        newY--;
    } else if ([dir isEqualToString:@"right"]) {
        newY++;
    } else { // dir.equals("down")
        newX++;
    }
    
    /* Check if a Path or a Wall */
    if (!(newX >= 0 && newX < self.size && newY >= 0 && newY < self.size) ||
        [self findLocationX:newX Y:newY Map:self.map].x == 3) {
        /* Fight monster, do nothing with hero */
        printf("FIGHTT!!!!!\n");
        code = 2;
    } else if ([self findLocationX:newX Y:newY Map:self.map].x == 2) { // YOU WIIN
        printf("VICTORY SCREEEECH!!");
        code = 3;
    } else {
        /* Add Item to Inventory if exists */
        Item *item = [self findLocationX:newX Y:newY Map:self.map].item;
        if (item != nil) {
            printf("PICKED UP ITEM %s", [[item toString] UTF8String]);
            [itemPicked appendFormat:@"PICKED UP ITEM %s", [[item toString] UTF8String]];
            [InventoryManager addToInventory:item];
        }
        /* Move hero */
        // OG Hero location to become (1,1) - Path
        [[_map objectAtIndex:self.heroX] replaceObjectAtIndex:self.heroY withObject: [[Space alloc] initx:1 y:1 item:nil]];
        // New Hero location to become (4,4) - Hero
        [[_map objectAtIndex:newX] replaceObjectAtIndex:newY withObject: [[Space alloc] initx:4 y:4 item:nil]];
        
        // Update Dungeon's Hero location
        self.heroX = newX;
        self.heroY = newY;
        code = 1;
    }
    /* Add to steps already taken */
    [mainCharacter addStepSpace:[[Space alloc] initx:newX y:newY item:nil]];
    return code;
}


-(NSMutableArray*)generateMap {
    NSMutableArray *tmpMap = [[NSMutableArray alloc] initWithCapacity:self.size];
    
    for (int i = 0; i < self.size; i++) {
        /* Put a new NSMutableArray into each spot of the *map Pointer*/
        // Insert a space with x = 3, y = 3 (Represents a nill path)
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:self.size];
        for (int k = 0; k < self.size; k++) {
            [arr insertObject:[[Space alloc] initx:3 y:3 item:nil] atIndex:k];
        }
        
        [tmpMap insertObject:arr atIndex:i];
    }
        
    /* Insert a Space(0,0,nil) at the start - the (0,0) Position on map*/
    [[tmpMap objectAtIndex:0] replaceObjectAtIndex:0 withObject:self.start];

    int x = 0;
    int y = 0;
    while (x != (self.size-1) && y != (self.size-1)) {
    
        int count = 0; // Determines if Generator is stuck
        BOOL valid = true;
        while (valid) {
            count++;
            
            /** Will this space contain an Item? **/
            BOOL isItem = false;
            int itemGenerated = arc4random_uniform(100);
            if (itemGenerated < ITEMGENERATEPERCENT) {
                isItem = true;
            }
            
            
            int direction = arc4random_uniform(100);
            
            if (direction >= 0 && direction < 25) { // Create Space UP Direction
                if (x-1 >= 0 && x-1 < self.size && y >= 0 && y < self.size && [self findLocationX:x-1 Y:y Map:tmpMap].x == 3) { // Check bounds, if not in bounds, try another move
                    if (isItem) {
                        Item *i = [ItemDictionary generateRandomItem:false];
                        [[tmpMap objectAtIndex:x-1] replaceObjectAtIndex:y withObject:[[Space alloc] initx:1 y:1 item:i]];
                    } else {
                        [[tmpMap objectAtIndex:x-1] replaceObjectAtIndex:y withObject:[[Space alloc] initx:1 y:1 item:nil]];
                    }
                    
                    x -= 1;
                    valid = false;
                }
            }
            
            if (direction >= 26 && direction < 50) { // Create Space RIGHT Direction
                if (x >= 0 && x < self.size && y+1 >= 0 && y+1 < self.size && [self findLocationX:x Y:y+1 Map:tmpMap].x == 3) { // Check bounds, if not in bounds, try another move
                    if (isItem) {
                        Item *i = [ItemDictionary generateRandomItem:false];
                        [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y+1 withObject:[[Space alloc] initx:1 y:1 item:i]];
                    } else {
                        [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y+1 withObject:[[Space alloc] initx:1 y:1 item:nil]];
                    }
                    y = y+1;
                    valid = false;
                }
            }
            
            if (direction >= 51 && direction < 75) { // Create Space LEFT Direction
                if (x >= 0 && x < self.size && y-1 >= 0 && y-1 < self.size && [self findLocationX:x Y:y-1 Map:tmpMap].x == 3) { // Check bounds, if not in bounds, try another move
                    if (isItem) {
                        Item *i = [ItemDictionary generateRandomItem:false];
                        [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y-1 withObject:[[Space alloc] initx:1 y:1 item:i]];
                    } else {
                        [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y-1 withObject:[[Space alloc] initx:1 y:1 item:nil]];
                    }
                    y = y-1;
                    valid = false;
                }
            } 
            
            if (direction >= 76 && direction <= 100) { // Create Space DOWN Direction
                if (x+1 >= 0 && x+1 < self.size && y >= 0 && y < self.size && [self findLocationX:x+1 Y:y Map:tmpMap].x == 3) { // Check bounds, if not in bounds, try another move
                    if (isItem) {
                        Item *i = [ItemDictionary generateRandomItem:false];
                        [[tmpMap objectAtIndex:x+1] replaceObjectAtIndex:y withObject:[[Space alloc] initx:1 y:1 item:i]];
                    } else {
                        [[tmpMap objectAtIndex:x+1] replaceObjectAtIndex:y withObject:[[Space alloc] initx:1 y:1 item:nil]];
                    }
                    x = x+1;
                    valid = false;
                }
            }
            
            if (valid && count > 20) { // generator is stuck
                if (x+1 >= 0 && x+1 < self.size && y >= 0 && y < self.size) {
                    [[tmpMap objectAtIndex:x+1] replaceObjectAtIndex:y withObject:
                     [[Space alloc] initx:3 y:3 item:nil]];
                } else if (x-1 >= 0 && x-1 < self.size && y >= 0 && y < self.size) {
                    [[tmpMap objectAtIndex:x-1] replaceObjectAtIndex:y withObject:
                     [[Space alloc] initx:3 y:3 item:nil]];
                } else if (x >= 0 && x < self.size && y+1 >= 0 && y+1 < self.size) {
                    [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y+1 withObject:
                     [[Space alloc] initx:3 y:3 item:nil]];
                } else {
                    [[tmpMap objectAtIndex:x] replaceObjectAtIndex:y-1 withObject:
                     [[Space alloc] initx:3 y:3 item:nil]];
                }
            }
            
        }
    
    } // End While
        
    
    /* Set and load in End Space */
    _end = [[Space alloc] initx:2 y:2 item:nil];
    [[tmpMap objectAtIndex:x] insertObject:self.end atIndex:y];
        
    return tmpMap;
}

-(NSMutableString*)printMap {
    NSMutableString *mapprint = [[NSMutableString alloc]init];
    for (int x = 0; x < self.size; x++) {
        for (int y = 0; y < self.size; y++) {
            Space *spot = [self findLocationX:x Y:y Map:self.map];
            if (spot.x == 4) {
                [mapprint appendString:@" H "];
            } else if (spot.x == 1) {
                [mapprint appendString:@" P "];
            } else if (spot.x == 3) {
                [mapprint appendString:@" W "];
            } else if (spot.x == 0) {
                [mapprint appendString:@" S "];
            } else { // END
                [mapprint appendString:@" E "];
            }
            
        }
        [mapprint appendString:@"\n"];
    }
    [mapprint appendString:@"\n"];
    return mapprint;
}


-(Space*)findLocationX:(int)x Y:(int)y Map:(NSMutableArray*)tmpMap {
//    printf("Size of row: %lu\n", (unsigned long)[tmpMap count]);
//    printf("Size of col: %lu\n", (unsigned long)[[tmpMap objectAtIndex:0] count]);
    return (Space*)[[tmpMap objectAtIndex:x] objectAtIndex:y];
}




@end
