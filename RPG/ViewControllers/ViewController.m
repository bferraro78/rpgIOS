
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
    
    /* Clear text field long tap */
    UILongPressGestureRecognizer *clearTextField = [[UILongPressGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(clearTextField:)];
    clearTextField.minimumPressDuration = 1.0; //seconds
    [_MainTextField addGestureRecognizer:clearTextField];
    
    
    // Generate Dungeon
    // TODO - Load dungeon
    _currMap = [[Dungeon alloc] initdungeonLevel:1 heroX:0 heroY:0];
    self.MapTextField.text = [_currMap printMap];
    
    
    /* Change Name of Buttons */
    [_printHero setTitle:mainCharacter.name forState:UIControlStateNormal];
    
    
}

-(void)clearTextField:(UILongPressGestureRecognizer *)gestureRecognizer {

    _mainText = [[NSMutableString alloc] init];
    self.MainTextField.text = _mainText;
    
    
}

- (IBAction)printHero:(id)sender { }
- (IBAction)inventory:(id)sender { }



- (IBAction)HeroStats:(id)sender {
    printf("\nPRINTSTATS:\n");
    [_mainText appendFormat:@"------------------\n%s", [[mainCharacter printStats] UTF8String]];
    self.MainTextField.text = _mainText;
    /* AUTO ROLL DOWN */
    NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
    [self.MainTextField scrollRangeToVisible:range];
}

- (IBAction)up:(id)sender {
    NSMutableString *itemPicked = [[NSMutableString alloc] init];
    int code = [_currMap moveHeroDirection:@"up" itemPicked:itemPicked];
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
    int code = [_currMap moveHeroDirection:@"down" itemPicked:itemPicked];
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
    int code = [_currMap moveHeroDirection:@"left" itemPicked:itemPicked];
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
    int code = [_currMap moveHeroDirection:@"right" itemPicked:itemPicked];
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
//        InventoryViewController *vc = [segue destinationViewController];
    }
    
    if ([[segue identifier] isEqualToString:@"equipSegue"]) {
//        EquipViewController *vc = [segue destinationViewController];
    }
    
    if ([[segue identifier] isEqualToString:@"combatSegue"]) {
//        CombatViewController *vc = [segue destinationViewController];
    }
    
    if ([[segue identifier] isEqualToString:@"skillSegue"]) {
//        SkillViewController *vc = [segue destinationViewController];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
