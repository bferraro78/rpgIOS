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
    self.title = mainCharacter.name;
    
    /* SET UP BUTTONS */
    if ([mainCharacter getMH].attack != 0) {
        [_mainHandButton setTitle:@"Main Hand" forState:UIControlStateNormal];
    } else {
        [_mainHandButton setTitle:@"Empty Main Hand" forState:UIControlStateNormal];
    }

    if ([mainCharacter getOH].attack != 0) {
        [_offHandButton setTitle:@"Off Hand" forState:UIControlStateNormal];
    } else {
        [_offHandButton setTitle:@"Empty Off Hand" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getHelm].armor != 0) {
        [_HelmetButton setTitle:@"Helmet Slot" forState:UIControlStateNormal];
    } else {
        [_HelmetButton setTitle:@"Empty Helmet" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getTorso].armor != 0) {
        [_TorsoButton setTitle:@"Torso Slot" forState:UIControlStateNormal];
    } else {
        [_TorsoButton setTitle:@"Empty Torso" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getShoulders].armor != 0) {
        [_ShouldersButton setTitle:@"Shoulders Slot" forState:UIControlStateNormal];
    } else {
        [_ShouldersButton setTitle:@"Empty Shoulders" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getBracers].armor != 0) {
        [_BracersButton setTitle:@"Bracers Slot" forState:UIControlStateNormal];
    } else {
        [_BracersButton setTitle:@"Empty Bracers" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getGloves].armor != 0) {
        [_GlovesButton setTitle:@"Gloves Slot" forState:UIControlStateNormal];
    } else {
        [_GlovesButton setTitle:@"Empty Gloves" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getLegs].armor != 0) {
        [_LegsButton setTitle:@"Legs Slot" forState:UIControlStateNormal];
    } else {
        [_LegsButton setTitle:@"Empty Legs" forState:UIControlStateNormal];
    }
    
    if ([mainCharacter getBoots].armor != 0) {
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

    UILongPressGestureRecognizer *lpgrMH = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleLongPressMH:)];
    lpgrMH.minimumPressDuration = 1.0; //seconds

    UILongPressGestureRecognizer *lpgrOH = [[UILongPressGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleLongPressOH:)];
    lpgrOH.minimumPressDuration = 1.0; //seconds

    
    [_mainHandButton addGestureRecognizer:lpgrMH];
    [_offHandButton addGestureRecognizer:lpgrOH];
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
    if ([mainCharacter getHelm].armor != 0) {
        _EquipmentText.text = [[mainCharacter getHelm] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)ShouldersButton:(id)sender {
    if ([mainCharacter getShoulders].armor != 0) {
        _EquipmentText.text = [[mainCharacter getShoulders] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)TorsoButton:(id)sender {
    if ([mainCharacter getTorso].armor != 0) {
        _EquipmentText.text = [[mainCharacter getTorso] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)BracersButton:(id)sender {
    if ([mainCharacter getBracers].armor != 0) {
        _EquipmentText.text = [[mainCharacter getBracers] toString];
    } else {
        _EquipmentText.text = @"";
    }
}
- (IBAction)GlovesButton:(id)sender {
    if ([mainCharacter getGloves].armor != 0) {
        _EquipmentText.text = [[mainCharacter getGloves] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)LegsButton:(id)sender {
    if ([mainCharacter getLegs].armor != 0) {
        _EquipmentText.text = [[mainCharacter getLegs] toString];
    } else {
        _EquipmentText.text = @"";
    }
    
}

- (IBAction)BootsButton:(id)sender {
    if ([mainCharacter getBoots].armor != 0) {
        _EquipmentText.text = [[mainCharacter getBoots] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)MainHandButton:(id)sender {
    if ([mainCharacter getMH].attack != 0) {
        _EquipmentText.text = [[mainCharacter getMH] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

- (IBAction)OffHandButton:(id)sender {
    if ([mainCharacter getOH].attack != 0) {
        _EquipmentText.text = [[mainCharacter getOH] toString];
    } else {
        _EquipmentText.text = @"";
    }
}

/* LONG PRESS BUTTON ACTIONS (UNEQUIP)*/
-(void)handleLongPressMH:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getMH].attack != 0) {
        [EquipmentManager unequipMH];
    }
    [_mainHandButton setTitle:@"Empty Main Hand" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressOH:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getOH].attack != 0) {
        [EquipmentManager unequipOH];
    }
    [_offHandButton setTitle:@"Empty Off Hand" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressHelmet:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getHelm].armor != 0) {
        [EquipmentManager unequipHelm];
    }
    [_HelmetButton setTitle:@"Empty Helmet" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressShoulders:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getShoulders].armor != 0) {
        [EquipmentManager unequipShoulders];
    }
    [_ShouldersButton setTitle:@"Empty Shoulders" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressTorso:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getTorso].armor != 0) {
        [EquipmentManager unequipTorso];
    }
    [_TorsoButton setTitle:@"Empty Torso" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressGloves:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getGloves].armor != 0) {
        [EquipmentManager unequipGloves];
    }
    [_GlovesButton setTitle:@"Empty Gloves" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressBracers:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getBracers].armor != 0) {
        [EquipmentManager unequipBracers];
    }
    [_BracersButton setTitle:@"Empty Bracers" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressLegs:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getLegs].armor != 0) {
        [EquipmentManager unequipLegs];
    }
    [_LegsButton setTitle:@"Empty Legs" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

-(void)handleLongPressBoots:(UILongPressGestureRecognizer *)gestureRecognizer {
    if ([mainCharacter getBoots].armor != 0) {
        [EquipmentManager unequipBoots];
    }
    [_BootsButton setTitle:@"Empty Boots" forState:UIControlStateNormal];
    _EquipmentText.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
