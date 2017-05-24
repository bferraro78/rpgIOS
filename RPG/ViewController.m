
//
//  ViewController.m
//  RPG
//
//  Created by Ben Ferraro on 5/13/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _MainTextField.editable = false;
    _MapTextField.editable = false;
    
    /** LOAD DICTIONARIES **/
    [ItemDictionary loadItems];
    [SkillDictionary loadSkills];
    [EnemyDictionary loadEnemies];
    [WeaponDictionary loadWeapons];
    [ArmorDictionary loadArmor];
    
    
    _mainCharacter = [[Barbarian alloc] initname:@"BEANOO!" classID:1 vit:40 strn:20 inti:10 dext:10 startX:0 startY:0 dungeonLvl:0];
    _currMap = [[Dungeon alloc] initdungeonLevel:1 heroX:0 heroY:0];
    self.MapTextField.text = [_currMap printMap];
    
    
    NSString *resourceName = [_mainCharacter getResourceName];
    printf("\n%s", [resourceName UTF8String]);
    printf("\n%s", [[_mainCharacter getClassName] UTF8String]);
    NSInteger rageNum = _mainCharacter.rage;
    printf("\nBARB Rage number: %ld\n", (long)rageNum);
    
    

    
//    [Combat initCombat:_mainCharacter];
    
    
    
    
    Weapon *wep = [WeaponDictionary generateRandomWeapon:_mainCharacter];
    [_mainCharacter equipWeapon:wep];
    
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:false]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:false]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    
}





- (IBAction)printHero:(id)sender {
    printf("\nPRINTBODY:\n");
    self.MainTextField.text = [_mainCharacter printBody];
}

- (IBAction)HeroStats:(id)sender {
    printf("Print Stats");
    self.MainTextField.text = [_mainCharacter printStats];
}

- (IBAction)inventory:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Inventory" bundle:nil];
    
    InventoryViewController *inventoryView = [storyboard instantiateViewControllerWithIdentifier:
                                              @"InventoryView"];
    
    inventoryView.mainCharacter = _mainCharacter;
    
    
    [self presentViewController:inventoryView animated:true completion:nil];

}


- (IBAction)up:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"up" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        // INITATE COMBAT
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    if ([itemPicked length] != 0) {
        self.MainTextField.text = itemPicked;
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)down:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"down" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        // INITATE COMBAT
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    if ([itemPicked length] != 0) {
        self.MainTextField.text = itemPicked;
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)left:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"left" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        // INITATE COMBAT
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    if ([itemPicked length] != 0) {
        self.MainTextField.text = itemPicked;
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)right:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"right" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        // INITATE COMBAT
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    if ([itemPicked length] != 0) {
        self.MainTextField.text = itemPicked;
    }
    self.MapTextField.text = [_currMap printMap];
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
