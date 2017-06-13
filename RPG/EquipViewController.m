//
//  EquipViewController.m
//  RPG
//
//  Created by Ben Ferraro on 5/25/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import "EquipViewController.h"
@interface EquipViewController ()

@end

@implementation EquipViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /* Text Field Non-Editable */
    _EquipmentText.editable = false;
    
    /* Set Name of Nav Bar to Hero's Name*/
    self.title = _mainCharacter.name;
    
    /* SET UP BUTTONS */
    if ([_mainCharacter getHelm].armor != 0) {
        [_HelmetButton setTitle:@"Helmet Slot" forState:UIControlStateNormal];
    } else {
        [_HelmetButton setTitle:@"Empty Helmet" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getTorso].armor != 0) {
        [_TorsoButton setTitle:@"Torso Slot" forState:UIControlStateNormal];
    } else {
        [_TorsoButton setTitle:@"Empty Torso" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getShoulders].armor != 0) {
        [_ShouldersButton setTitle:@"Shoulders Slot" forState:UIControlStateNormal];
    } else {
        [_ShouldersButton setTitle:@"Empty Shoulders" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getBracers].armor != 0) {
        [_BracersButton setTitle:@"Bracers Slot" forState:UIControlStateNormal];
    } else {
        [_BracersButton setTitle:@"Empty Bracers" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getGloves].armor != 0) {
        [_GlovesButton setTitle:@"Gloves Slot" forState:UIControlStateNormal];
    } else {
        [_GlovesButton setTitle:@"Empty Gloves" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getLegs].armor != 0) {
        [_LegsButton setTitle:@"Legs Slot" forState:UIControlStateNormal];
    } else {
        [_LegsButton setTitle:@"Empty Legs" forState:UIControlStateNormal];
    }
    
    if ([_mainCharacter getBoots].armor != 0) {
        [_BootsButton setTitle:@"Boots Slot" forState:UIControlStateNormal];
    } else {
        [_BootsButton setTitle:@"Empty Boots" forState:UIControlStateNormal];
    }
 
    
    /* SET UP BUTTON GESTURES */
    UILongPressGestureRecognizer *lpgrHelmet = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPressHelmet:)];
    lpgrHelmet.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrShoulders = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPressShoulders:)];
    lpgrShoulders.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrTorso = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(handleLongPressTorso:)];
    lpgrTorso.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrBracers = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(handleLongPressBracers:)];
    lpgrBracers.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrGloves = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleLongPressGloves:)];
    lpgrGloves.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrLegs = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleLongPressLegs:)];
    lpgrLegs.minimumPressDuration = 1.0; //seconds
    
    UILongPressGestureRecognizer *lpgrBoots = [[UILongPressGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleLongPressBoots:)];
    lpgrBoots.minimumPressDuration = 1.0; //seconds
    
    [_HelmetButton addGestureRecognizer:lpgrHelmet];
    [_ShouldersButton addGestureRecognizer:lpgrShoulders];
    [_TorsoButton addGestureRecognizer:lpgrTorso];
    [_GlovesButton addGestureRecognizer:lpgrGloves];
    [_BracersButton addGestureRecognizer:lpgrBracers];
    [_LegsButton addGestureRecognizer:lpgrLegs];
    [_BootsButton addGestureRecognizer:lpgrBoots];
    
}

/* PRESS BUTTON ACTIONS */
- (IBAction)HelmetButton:(id)sender {
    if ([_mainCharacter getHelm].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getHelm] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)ShouldersButton:(id)sender {
    if ([_mainCharacter getShoulders].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getShoulders] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)TorsoButton:(id)sender {
    if ([_mainCharacter getTorso].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getTorso] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)BracersButton:(id)sender {
    if ([_mainCharacter getBracers].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getBracers] toString];
    } else {
        _EquipmentText.text = @"";
    }
}
- (IBAction)GlovesButton:(id)sender {
    if ([_mainCharacter getGloves].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getGloves] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)LegsButton:(id)sender {
    if ([_mainCharacter getLegs].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getLegs] toString];
    } else {
        _EquipmentText.text = @"";
    }
    
}

- (IBAction)BootsButton:(id)sender {
    if ([_mainCharacter getBoots].armor != 0) {
        _EquipmentText.text = [[_mainCharacter getBoots] toString];
    } else {
        _EquipmentText.text = @"";
    }
}


/* LONG PRESS BUTTON ACTIONS (UNEQUIP)*/
-(void)handleLongPressHelmet:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getHelm].armor != 0) {
        [_mainCharacter unequipHelm];
    }
    [_HelmetButton setTitle:@"Empty Helmet" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressShoulders:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getShoulders].armor != 0) {
        [_mainCharacter unequipShoulders];
    }
    [_ShouldersButton setTitle:@"Empty Shoulders" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressTorso:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getTorso].armor != 0) {
        [_mainCharacter unequipTorso];
    }
    [_TorsoButton setTitle:@"Empty Torso" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressGloves:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getGloves].armor != 0) {
        [_mainCharacter unequipGloves];
    }
    [_GlovesButton setTitle:@"Empty Gloves" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressBracers:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getBracers].armor != 0) {
        [_mainCharacter unequipBracers];
    }
    [_BracersButton setTitle:@"Empty Bracers" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressLegs:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getLegs].armor != 0) {
        [_mainCharacter unequipLegs];
    }
    [_LegsButton setTitle:@"Empty Legs" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressBoots:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([_mainCharacter getBoots].armor != 0) {
        [_mainCharacter unequipBoots];
    }
    [_BootsButton setTitle:@"Empty Boots" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
