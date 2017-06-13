
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

NSMutableString *mainText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _MainTextField.editable = false;
    _MapTextField.editable = false;
    
    _mainText = [[NSMutableString alloc] init];
    
    /** LOAD DICTIONARIES **/
    [ItemDictionary loadItems];
    [SkillDictionary loadSkills];
    [EnemyDictionary loadEnemies];
    [WeaponDictionary loadWeapons];
    [ArmorDictionary loadArmor];
    [BuffDictionary loadBuffLibrary];
    
    
    _mainCharacter = [[Barbarian alloc] initname:@"BEANOOOOOOOOOO!" classID:1 vit:40 strn:10 inti:20 dext:10 startX:0 startY:0 dungeonLvl:0];
    
    _currMap = [[Dungeon alloc] initdungeonLevel:1 heroX:0 heroY:0];
    self.MapTextField.text = [_currMap printMap];
    
    
    NSString *resourceName = [_mainCharacter getResourceName];
    printf("\n%s", [resourceName UTF8String]);
    printf("\n%s", [[_mainCharacter getClassName] UTF8String]);
    NSInteger rageNum = [_mainCharacter getResource];
    printf("\nWizard Mana number: %ld\n", (long)rageNum);
    
    
    /* Change Name of Buttons */
    [_printHero setTitle:_mainCharacter.name forState:UIControlStateNormal];
    
    Weapon *wep = [WeaponDictionary generateRandomWeapon:_mainCharacter];
    [_mainCharacter equipWeapon:wep];
    
    // ADD HEALTH PIECE
    Armor *healthPiece = [[Armor alloc] initarmorID:999 armorName:@"Health piece" armorType:@"Torso"];
    healthPiece.armorVit = 1000;
    [_mainCharacter addToInventory:healthPiece];
    
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:true]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ItemDictionary generateRandomItem:false]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
    [_mainCharacter addToInventory:[ArmorDictionary generateRandomArmor:_mainCharacter]];
}

- (IBAction)printHero:(id)sender { }
- (IBAction)inventory:(id)sender { }



- (IBAction)HeroStats:(id)sender {
    printf("\nPRINTSTATS:\n");
    [_mainText appendFormat:@"------------------\n%s", [[_mainCharacter printStats] UTF8String]];
    self.MainTextField.text = _mainText;
    /* AUTO ROLL DOWN */
    NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
    [self.MainTextField scrollRangeToVisible:range];
}

- (IBAction)up:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"up" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        /* INITATE COMBAT */
         [self performSegueWithIdentifier:@"combatSegue" sender:sender];
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    
    if ([itemPicked length] != 0) {
        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
        self.MainTextField.text = _mainText;
        /* AUTO ROLL DOWN */
        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
        [self.MainTextField scrollRangeToVisible:range];
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)down:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"down" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        /* INITATE COMBAT */
        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    
    if ([itemPicked length] != 0) {
        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
        self.MainTextField.text = _mainText;
        /* AUTO ROLL DOWN */
        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
        [self.MainTextField scrollRangeToVisible:range];
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)left:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"left" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        /* INITATE COMBAT */
        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    
    if ([itemPicked length] != 0) {
        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
        self.MainTextField.text = _mainText;
        /* AUTO ROLL DOWN */
        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
        [self.MainTextField scrollRangeToVisible:range];
    }
    self.MapTextField.text = [_currMap printMap];
}
- (IBAction)right:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"right" Hero:_mainCharacter itemPicked:itemPicked];
    if (code == 2) {
        /* INITATE COMBAT */
        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
    } else if (code == 3) {
        // INITATE VICTORY DUNGEON
    }
    
    if ([itemPicked length] != 0) {
        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
        self.MainTextField.text = _mainText;
        /* AUTO ROLL DOWN */
        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
        [self.MainTextField scrollRangeToVisible:range];
    }
    self.MapTextField.text = [_currMap printMap];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"inventorySegue"]) {
        // Get reference to the destination view controller
        InventoryViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here
        vc.mainCharacter = self.mainCharacter;
    }
    
    if ([[segue identifier] isEqualToString:@"equipSegue"]) {
        // Get reference to the destination view controller
        EquipViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here
        vc.mainCharacter = self.mainCharacter;
    }
    
    if ([[segue identifier] isEqualToString:@"combatSegue"]) {
        // Get reference to the destination view controller
        CombatViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here
        vc.mainCharacter = self.mainCharacter;
    }
    
    if ([[segue identifier] isEqualToString:@"skillSegue"]) {
  
        // Get reference to the destination view controller
        SkillViewController *vc = [segue destinationViewController];
    
        // Pass any objects to the view controller here
        vc.mainCharacter = self.mainCharacter;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
