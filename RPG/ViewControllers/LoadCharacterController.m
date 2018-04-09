//
//  LoadCharacterController.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadCharacterController.h"

@implementation LoadCharacterController

-(void)viewDidLoad {
    [super viewDidLoad];
 
    /** LOAD DICTIONARIES **/
    [ItemDictionary loadItems];
    [SkillDictionary loadSkills];
    [EnemyDictionary loadEnemies];
    [WeaponDictionary loadWeapons];
    [ArmorDictionary loadArmor];
    [BuffDictionary loadBuffLibrary];
    
    // TODO - LOAD/CREATE HEROOO
    _h1 = [[Barbarian alloc] initname:@"Barb" classID:1 vit:40 strn:20 inti:10 dext:10 startX:0 startY:0 dungeonLvl:0];
    _h2 = [[Wizard alloc] initname:@"Zard" classID:1 vit:40 strn:10 inti:20 dext:10 startX:0 startY:0 dungeonLvl:0];
    
    
    // ADD HEALTH PIECE -- TODO DEBUG
//    Armor *healthPiece = [[Armor alloc] initarmorID:999 armorName:@"Health piece" armorType:@"Torso"];
//    healthPiece.armorVit = 1000;
//    healthPiece.armor = 10;
//    [InventoryManager addToInventory:healthPiece];
//
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:false]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ItemDictionary generateRandomItem:true]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[ArmorDictionary generateRandomArmor]];
//    [InventoryManager addToInventory:[WeaponDictionary generateRandomWeapon]];
//    [InventoryManager addToInventory:[WeaponDictionary generateRandomWeapon]];
//    [InventoryManager addToInventory:[WeaponDictionary generateRandomWeapon]];

    /* Change Name of Buttons */
    [_CharacterOneButton setTitle:_h1.name forState:UIControlStateNormal];
    [_CharacterTwoButton setTitle:_h2.name forState:UIControlStateNormal];
    
}

- (IBAction)CharacterTwoButton:(id)sender {
    mainCharacter = _h2;
}

-(IBAction)CharacterOneButton:(id)sender {
    mainCharacter = _h1;
}


@end
