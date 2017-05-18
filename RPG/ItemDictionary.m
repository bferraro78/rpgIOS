//
//  ItemDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemDictionary.h"
@implementation ItemDictionary

NSMutableArray *itemLibrary;


/* Load Items -- Called When Game is Started */
+(void)loadItems {
    printf("LOADING ITEMS...\n");

    itemLibrary = [[NSMutableArray alloc] init];

    [itemLibrary addObject:[[Firestone alloc] initdescription:@"Boost Fire Damage and Resistance" Element:@"FIRE"]];
    [itemLibrary addObject:[[Coldstone alloc] initdescription:@"Boost Cold Damage and Resistance" Element:@"COLD"]];
    [itemLibrary addObject:[[Lightningstone alloc] initdescription:@"Boost Lightning Damage and Resistance" Element:@"LIGHTNING"]];
    [itemLibrary addObject:[[Arcanestone alloc] initdescription:@"Boost Arcane Damage and Resistance"
                                                             Element:@"ARCANE"]];
    [itemLibrary addObject:[[Poisonstone alloc] initdescription:@"Boost Poison Damage and Resistance"
                                                             Element:@"POISON"]];
    [itemLibrary addObject:[[XPBoost alloc] initdescription:@"Boost XP Gain"]];
    
    int size = (int)[itemLibrary count];
    printf("Size of ItemLib: %i\n", size);
}


/* Generate Random Item */
+(Item*)generateRandomItem {
    int size = (int)[itemLibrary count];
    int choice = arc4random_uniform(size);
    Item *chosenItem = [itemLibrary objectAtIndex:choice];
    
    return chosenItem;
}

+(Item*)findItem:(NSString*)s {
    for (int i = 0; i < [itemLibrary count]; i++) {
        Item *tmp = [itemLibrary objectAtIndex:i];
        if ([[tmp getType] isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end