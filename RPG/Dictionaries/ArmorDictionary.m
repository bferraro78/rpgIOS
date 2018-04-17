//
//  ArmorDictionary.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArmorDictionary.h"
@implementation ArmorDictionary

NSMutableArray *armorLibrary;


/* Load Armors -- Called When Game is Started */
+(void)loadArmor {
    printf("LOADING ARMORS...\n");
    
    armorLibrary = [[NSMutableArray alloc] init];
    
    // LOAD ARMOR
    
    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:1 armorName:@"HELM OF GAWDS" armorType:HELMET]];
    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:2 armorName:@"LEGS OF GAWDS" armorType:LEGS]];
    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:3 armorName:@"BOOTS OF GAWDS" armorType:BOOTS]];
    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:4 armorName:@"TORSO OF GAWDS" armorType:TORSO]];
    

    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:5 armorName:@"Leather Torso" armorType:TORSO]];
    [armorLibrary addObject:[[Armor alloc] initForRandomStatsarmorID:6 armorName:@"Leather Legs" armorType:LEGS]];
    
}


/* Generate Random Item */
+(Armor*)generateRandomArmor {
    int size = (int)[armorLibrary count];
    int choice = arc4random_uniform(size);
    
    /* Make copy of template from library */
    Armor *tmpArmor = [armorLibrary objectAtIndex:choice];
    Armor *chosenArmor = [[Armor alloc] initForRandomStatsarmorID:tmpArmor.armorID
                                          armorName:tmpArmor.armorName armorType:tmpArmor.armorType];
    
    /* Get Hero stats and generate Armor stats base on level */
    int heroLevel = mainCharacter.level;
    
    chosenArmor.armor = arc4random_uniform(heroLevel+50)+heroLevel+10;
    
    if (heroLevel < 20) {
        chosenArmor.armorVit = arc4random_uniform(heroLevel+10)+heroLevel;
        chosenArmor.armorStrn = arc4random_uniform(heroLevel+10)+heroLevel;
        chosenArmor.armorInti = arc4random_uniform(heroLevel+10)+heroLevel;
        chosenArmor.armorDext = arc4random_uniform(heroLevel+10)+heroLevel;
        chosenArmor.armorResistance = arc4random_uniform(5);
    } else if (heroLevel < 60) {
        chosenArmor.armorVit = arc4random_uniform(heroLevel+20)+(heroLevel-10);
        chosenArmor.armorStrn = arc4random_uniform(heroLevel+15)+(heroLevel-10);
        chosenArmor.armorInti = arc4random_uniform(heroLevel+15)+(heroLevel-10);
        chosenArmor.armorDext = arc4random_uniform(heroLevel+15)+(heroLevel-10);
        chosenArmor.armorResistance = arc4random_uniform(11)+5;
    } else {
        chosenArmor.armorVit = arc4random_uniform(heroLevel+30)+(heroLevel-10);
        chosenArmor.armorStrn = arc4random_uniform(heroLevel+20)+(heroLevel-10);
        chosenArmor.armorInti = arc4random_uniform(heroLevel+20)+(heroLevel-10);
        chosenArmor.armorDext = arc4random_uniform(heroLevel+20)+(heroLevel-10);
        chosenArmor.armorResistance = arc4random_uniform(21)+10;
    }
    
    
    
    /* 50% Chance item is physical damage - 50% elemental */
    int elementalOrPhysical = arc4random_uniform(100);
    if (elementalOrPhysical < 49) {
        chosenArmor.armorElement = PHYSICAL;
    } else {
        int elementChoice = arc4random_uniform(4);
        if (elementChoice == 0) {
            chosenArmor.armorElement = FIRE;
        } else if (elementChoice == 1) {
            chosenArmor.armorElement = COLD;
        } else if (elementChoice == 2) {
            chosenArmor.armorElement = LIGHTNING;
        } else if (elementChoice == 3) {
            chosenArmor.armorElement = POISON;
        } else { // Arcane
            chosenArmor.armorElement = ARCANE;
        }
    }
    
    return chosenArmor;
}



+(Armor*)findArmor:(NSString*)s {
    for (int i = 0; i < [armorLibrary count]; i++) {
        Armor *tmp = [armorLibrary objectAtIndex:i];
        if ([tmp.armorName isEqualToString:s]) {
            return tmp;
        }
    }
    return nil;
}

@end
