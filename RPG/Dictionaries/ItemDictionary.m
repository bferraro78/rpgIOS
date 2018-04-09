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

    // TODO - ADD HEALTH POTIONS - mainly for barbs an rogues
    
    itemLibrary = [[NSMutableArray alloc] init];

    [itemLibrary addObject:[[Firestone alloc] initdescription:@"Boost Fire Damage and Resistance" Element:FIRE]];
    [itemLibrary addObject:[[Coldstone alloc] initdescription:@"Boost Cold Damage and Resistance" Element:COLD]];
    [itemLibrary addObject:[[Lightningstone alloc] initdescription:@"Boost Lightning Damage and Resistance" Element:LIGHTNING]];
    [itemLibrary addObject:[[Arcanestone alloc] initdescription:@"Boost Arcane Damage and Resistance"
                                                             Element:ARCANE]];
    [itemLibrary addObject:[[Poisonstone alloc] initdescription:@"Boost Poison Damage and Resistance"
                                                             Element:POISON]];
    [itemLibrary addObject:[[XPBoost alloc] initdescription:@"Boost XP Gain"]];
    // add potion here
    
    // Keep Scroll as last element always, this item is not to be included if dropped from an ememy
    [itemLibrary addObject:[[ElementScroll alloc] initdescription:@"Gain a New Elemental Ability"]];
}


/* Generate Random Item */
+(Item*)generateRandomItem:(BOOL)isLoot {
    /* Different items can be generated depening on if it is
     * loot verses map item */
    
    int size = (int)[itemLibrary count];
    int choice;
    if (isLoot || ![mainCharacter.elementSpec isEqualToString:PHYSICAL]) { // loot doesn't contain elemental scrolls
        choice = arc4random_uniform(size)-1;
        if (choice < 0) { choice = 0; }
    } else {
        choice = arc4random_uniform(size);
    }
    
    /* Make copy of template from library (SO we do not change the actual item in the library) */
    Item *tmpItem = [itemLibrary objectAtIndex:choice];
    Item *chosenItem;
    if ([tmpItem isKindOfClass:[Firestone class]]) {
        chosenItem = [[Firestone alloc] initdescription:tmpItem.description Element:FIRE];
    } else if ([tmpItem isKindOfClass:[Coldstone class]]) {
        chosenItem = [[Coldstone alloc] initdescription:tmpItem.description Element:COLD];
    } else if ([tmpItem isKindOfClass:[Lightningstone class]]) {
        chosenItem = [[Lightningstone alloc] initdescription:tmpItem.description Element:LIGHTNING];
    } else if ([tmpItem isKindOfClass:[Arcanestone class]]) {
        chosenItem = [[Poisonstone alloc] initdescription:tmpItem.description Element:POISON];
    } else if ([tmpItem isKindOfClass:[Poisonstone class]]) {
        chosenItem = [[Arcanestone alloc] initdescription:tmpItem.description Element:ARCANE];
    } else if ([tmpItem isKindOfClass:[XPBoost class]]) {
        chosenItem = [[XPBoost alloc] initdescription:tmpItem.description];
    } else { // elemental scroll
        chosenItem = [[ElementScroll alloc] initdescription:tmpItem.description];
    }
    
    /* Generates Potency of Item - does noting for Element Scroll */
    [chosenItem generate];
    
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
