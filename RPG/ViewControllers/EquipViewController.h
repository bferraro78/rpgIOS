//
//  EquipViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/25/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCharacter.h"
#import "EquipmentManager.h"

@interface EquipViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *HelmetButton;

@property (strong, nonatomic) IBOutlet UIButton *ShouldersButton;

@property (strong, nonatomic) IBOutlet UIButton *TorsoButton;
@property (strong, nonatomic) IBOutlet UIButton *GlovesButton;

@property (strong, nonatomic) IBOutlet UIButton *BracersButton;
@property (strong, nonatomic) IBOutlet UIButton *LegsButton;
@property (strong, nonatomic) IBOutlet UIButton *BootsButton;
@property (strong, nonatomic) IBOutlet UIButton *mainHandButton;
@property (strong, nonatomic) IBOutlet UIButton *offHandButton;

@property (strong, nonatomic) IBOutlet UITextView *EquipmentText;


@end
