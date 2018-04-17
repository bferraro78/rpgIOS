//
//  InventoryManager.m
//  RPG
//
//  Created by james schuler on 4/3/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventoryManager.h"

@implementation InventoryManager

/**** Inventory Management ****/

/* Gold Function */
+(void)changePurse:(int)gold { mainCharacter.purse = (mainCharacter.purse+gold); }

+(void)equipOrActivateItemArmorWeapon:(NSObject*)invItem {
    
    if ([invItem isKindOfClass:[Armor class]]) { // Armor
        Armor *tmp = (Armor *) invItem;
        
        [EquipmentManager equipArmor:tmp];
        
        printf("%s",[[tmp toString] UTF8String]);
        
    } else if ([invItem isKindOfClass:[Weapon class]]) { // Wep
        Weapon *tmp = (Weapon *) invItem;
        
        [EquipmentManager equipWeapon:tmp];
        
        printf("%s",[[tmp toString] UTF8String]);
        
    } else {
        Item *tmp = (Item *) invItem;
        printf("%s",[[tmp toString] UTF8String]);
        
        /* Activate Item */
        [self activateItem:tmp];
    }
}

/** ITEM HANDLING -- ADD NEW ITEM TYPES HERE **/
+(void)activateItem:(Item*)item {
    
    if ([[item getType]isEqualToString:@"ElementScroll"]) {
        /* Select a random skill from that element (that is level approriate)
         * Add it to mainCharcters skillSet */
        if ([mainCharacter.elementSpec isEqualToString:FIRE]) {
            
        } else if ([mainCharacter.elementSpec isEqualToString:COLD]) {
            
        } else if ([mainCharacter.elementSpec isEqualToString:POISON]) {
            
        } else if ([mainCharacter.elementSpec isEqualToString:LIGHTNING]) {
            
        } else if ([mainCharacter.elementSpec isEqualToString:ARCANE]) {
            
        }
        
        /* Remove from Inventory */
        [self removeFromInventory:item];
        
    } else {    
        if ([mainCharacter.activeItems count] >= 4) { // if more than four items active, must delete one
            [self removeActiveItem];
        } else {
            /* Add active Item Buff to Hero's ActiveItem Array and Activate Buff */
            if([[item getType] rangeOfString:@"stone"].location != NSNotFound) {
                [mainCharacter increaseResistance:[item getElement] increaseBy:[item getPotency]];
                /* Add to Active Item Buffs Array */
                [mainCharacter.activeItems addObject:item];
                
            } else if ([[item getType]isEqualToString:@"XPBoost"]) {
                /* Add to Active Item Buffs Array */
                [mainCharacter.activeItems addObject:item];
                
            }
            
            /* Remove from Inventory */
            [self removeFromInventory:item];
            
        }
        
        
    }
}

+(void)removeActiveItem {
    /* Loading alert box */
    UIAlertController *alertControllerDeleteActiveItem = [UIAlertController
                                                          alertControllerWithTitle:@"Only four active items allowed"
                                                          message:@"Remove one?"
                                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *activeItemOne = [UIAlertAction actionWithTitle:[[mainCharacter.activeItems objectAtIndex:0] toString]
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              Item *i = (Item*)[mainCharacter.activeItems objectAtIndex:0];
                                                              [self deactivateItem:i index:0];
                                                          }];
    
    UIAlertAction *activeItemTwo = [UIAlertAction actionWithTitle:[[mainCharacter.activeItems objectAtIndex:1] toString]
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              Item *i = (Item*)[mainCharacter.activeItems objectAtIndex:1];
                                                              [self deactivateItem:i index:1];
                                                              
                                                          }];
    
    UIAlertAction *activeItemThree = [UIAlertAction actionWithTitle:[[mainCharacter.activeItems objectAtIndex:2] toString]
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                Item *i = (Item*)[mainCharacter.activeItems objectAtIndex:2];
                                                                [self deactivateItem:i index:2];
                                                                
                                                            }];
    
    UIAlertAction *activeItemFour = [UIAlertAction actionWithTitle:[[mainCharacter.activeItems objectAtIndex:3] toString]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               Item *i = (Item*)[mainCharacter.activeItems objectAtIndex:3];
                                                               [self deactivateItem:i index:3];
                                                           }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) { }];
    
    [alertControllerDeleteActiveItem addAction:activeItemOne];
    [alertControllerDeleteActiveItem addAction:activeItemTwo];
    [alertControllerDeleteActiveItem addAction:activeItemThree];
    [alertControllerDeleteActiveItem addAction:activeItemFour];
    [alertControllerDeleteActiveItem addAction:noAction];
    
    UIViewController *currentVc = [(UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController topViewController];
    [currentVc presentViewController:alertControllerDeleteActiveItem animated:YES completion:nil];
    
}

+(void)deactivateItem:(Item*)item index:(int)index {
    /* Remove active Item Buff to Hero's ActiveItem Array and Activate Buff */
    if([[item getType] rangeOfString:@"stone"].location != NSNotFound) {
        [mainCharacter decreaseResistance:[item getElement] decreaseBy:[item getPotency]];
    }
    
    [mainCharacter.activeItems removeObjectAtIndex:index];
}

+(void)addToInventory:(id)o {
    [mainCharacter.inventory addObject:o];
}

+(void)removeFromInventory:(id)o {
    if ([mainCharacter.inventory indexOfObject:o] != NSNotFound) {
        [mainCharacter.inventory removeObjectAtIndex:[mainCharacter.inventory indexOfObject:o]];
    }
}

+(void)receiveLoot:(NSMutableArray*)loot {
    for (int i = 0; i < [loot count]; i++) {
        id tmp = [loot objectAtIndex:i];
        [self addToInventory:tmp];
    }
}


@end
