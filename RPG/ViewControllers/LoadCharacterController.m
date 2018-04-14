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

-(void)viewDidAppear:(BOOL)animated {
    // Clear Party if switching heroes before
    [[Party getPartyArray] clearParty];
    [[MCManager getMCManager].session disconnect];
}

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
    _h1 = [[Barbarian alloc] initNewCharacterName:@"Barbarian" vit:40 strn:20 inti:10 dext:10];
    _h2 = [[Wizard alloc] initNewCharacterName:@"Wizard" vit:30 strn:10 inti:20 dext:10];
    _h3 = [[Rogue alloc] initNewCharacterName:@"Rogue" vit:40 strn:10 inti:10 dext:20];
    

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
    [_CharacterThreeButton setTitle:_h3.name forState:UIControlStateNormal];
    
}

-(IBAction)CharacterOneButton:(id)sender {
    mainCharacter = _h1;
    // ADD HEALTH PIECE -- TODO DEBUG
    Armor *healthPiece = [[Armor alloc] initarmorID:999 armorName:@"Health piece" armorType:@"Torso"];
    healthPiece.armorVit = 1000;
    healthPiece.armor = 10;
    [EquipmentManager equipArmor:healthPiece];
    Weapon *w = [WeaponDictionary generateRandomWeapon];
    Weapon *w1 = [WeaponDictionary generateRandomWeapon];
    Weapon *w2 = [WeaponDictionary generateRandomWeapon];
    [EquipmentManager equipWeapon:w];
    [InventoryManager addToInventory:w1];
    [InventoryManager addToInventory:w2];
}

- (IBAction)CharacterTwoButton:(id)sender {
    mainCharacter = _h2;
    // ADD HEALTH PIECE -- TODO DEBUG
    Armor *healthPiece = [[Armor alloc] initarmorID:999 armorName:@"Health piece" armorType:@"Torso"];
    healthPiece.armorVit = 1000;
    healthPiece.armor = 10;
    [EquipmentManager equipArmor:healthPiece];
}

- (IBAction)CharacterThreeButton:(id)sender {
    mainCharacter = _h3;
    // ADD HEALTH PIECE -- TODO DEBUG
    Armor *healthPiece = [[Armor alloc] initarmorID:999 armorName:@"Health piece" armorType:@"Torso"];
    healthPiece.armorVit = 1000;
    healthPiece.armor = 10;
    [EquipmentManager equipArmor:healthPiece];
}


@end
