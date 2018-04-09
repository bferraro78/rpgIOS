//
//  LoadCharacterController.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef LoadCharacterController_h
#define LoadCharacterController_h
#import <UIKit/UIKit.h>
#import "MainCharacter.h"

#import "WeaponDictionary.h"
#import "ArmorDictionary.h"
#import "InventoryManager.h"

#import "CombatViewController.h"
#import "InventoryViewController.h"
#import "EquipViewController.h"
#import "SkillViewController.h"

#import "Barbarian.h"
#import "Wizard.h"
#import "Rogue.h"

@interface LoadCharacterController : UIViewController

@property Hero *h1;
@property Hero *h2;

@property (strong, nonatomic) IBOutlet UIButton *CharacterOneButton;
@property (strong, nonatomic) IBOutlet UIButton *CharacterTwoButton;

@end

#endif /* LoadCharacterController_h */
