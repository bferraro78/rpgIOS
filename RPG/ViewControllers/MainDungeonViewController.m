//
//  MainDungeonViewController.m
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainDungeonViewController.h"
@implementation MainDungeonViewController

NSMutableString *mainText;

-(void)viewWillAppear:(BOOL)animated {
    [self.tabBarController setTitle:@"Dungeon"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    // Indivdual member
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updatePartyMemberHero:)
                                                 name:@"UpdatePartyMemberHeroNotification"
                                               object:nil];
    
    
    /*
       Once you enter the dungeon there is no return
       1. Allow no more connections
       2. No back on navigator bar
     */
    [[MCManager getMCManager] advertiseSelf:false];
    
    _mainText = [[NSMutableString alloc] init]; // updateable string for main text field
    _MainTextField.editable = false;
    _MainTextField.text = _mainText;
    
    /* Clear text field long tap */
    UILongPressGestureRecognizer *clearTextField = [[UILongPressGestureRecognizer alloc]
                                                    initWithTarget:self action:@selector(clearTextField:)];
    clearTextField.minimumPressDuration = 1.0; //seconds
    [_MainTextField addGestureRecognizer:clearTextField];
    
    [_mainText appendFormat:@"Starting Dungeon"];
    self.MainTextField.text = _mainText;
    
}

-(void)setUpTabBarView {
    self.navigationController.title = @"Dungeon";
    UITabBarItem *bitem = [[UITabBarItem alloc] initWithTitle:@"Dungeon" image:nil tag:1];
    self.tabBarItem = bitem;
}

-(void)clearTextField:(UILongPressGestureRecognizer *)gestureRecognizer {
    _mainText = [[NSMutableString alloc] init];
    self.MainTextField.text = _mainText;
}

/** NOTIFICATION FUNCTIONS **/
/* Get Connection from user, really only used is party member is disconnected... :( */
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    Party *partyArray = [Party getPartyArray];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            // Once you enter a dungeon, no more connections allowed...
        } else if (state == MCSessionStateNotConnected) {
            if ([partyArray partyCount] > 0) {
                [partyArray removeFromParty:peerDisplayName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updatePartyTextRemove:peerDisplayName];
                });
            }
        }
    }
}
-(void)updatePartyTextRemove:(NSString*)partyMember {
    [_mainText appendFormat:@"\n\n%s has left the party..\n", [partyMember UTF8String]];
    self.MainTextField.text = _mainText;
    /* AUTO ROLL DOWN */
    NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
    [self.MainTextField scrollRangeToVisible:range];
}

-(void)updatePartyMemberHero:(NSNotification *)notification {
    NSDictionary *partyMemberInfo = [[notification userInfo] objectForKey:@"receivedData"];
    // has @"action" and Hero data dictionary
    
    // Update Party Member Hero in the PartyMemberArray
    PartyMember *member = [[Party getPartyArray] getPartyMember:partyMemberInfo[@"name"]];
    [member loadExistingPartyMemberFromDictionary:partyMemberInfo];
}


/** Buttons **/

/* TESTING COMBAT PURPOSES!
 1. Must send my "updated" hero, to all other party members
 2. Load all recieved party members into party array
 3. Enter combat
 */
-(IBAction)CombatButton:(id)sender {
    [self updateHeroDataForAllOtherPartyMembers]; // 1.
    [self performSegueWithIdentifier:@"combatSegue" sender:nil]; // 3.
}

-(void)updateHeroDataForAllOtherPartyMembers {
    PartyMember *member = [[Party getPartyArray] getPartyMember:mainCharacter.name];
    NSMutableDictionary *dictionaryToSend = [member partyMemberToDictionary];
    dictionaryToSend[@"action"] = @"updatePartyMemberHero";
    [[SendDataMCManager getSender] sendDictionaryOfInfo:dictionaryToSend];
}






/***
 
    1. Write text to UI
    2. Give option button to all peers
    3. once someone hits an option, send notification to all peers, udate decision map, and advance text
 
 ***/








/* Segues */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"heroProfileSegue"]) {
        HeroProfileViewController *profile = [segue destinationViewController];
        profile.partyMember = [[Party getPartyArray] getPartyMember:mainCharacter.name];
    }

    if ([[segue identifier] isEqualToString:@"combatSegue"]) {
        
    }
    
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


//- (IBAction)up:(id)sender {
//    NSMutableString *itemPicked = [[NSMutableString alloc] init];
//    int code = [_currMap moveHeroDirection:@"up" itemPicked:itemPicked];
//    if (code == 2) {
//        /* INITATE COMBAT */
//         [self performSegueWithIdentifier:@"combatSegue" sender:sender];
//    } else if (code == 3) {
//        // INITATE VICTORY DUNGEON
//    }
//
//    if ([itemPicked length] != 0) {
//        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
//        self.MainTextField.text = _mainText;
//        /* AUTO ROLL DOWN */
//        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
//        [self.MainTextField scrollRangeToVisible:range];
//    }
//    self.MapTextField.text = [_currMap printMap];
//}
//- (IBAction)down:(id)sender {
//    NSMutableString *itemPicked = [[NSMutableString alloc] init];
//    int code = [_currMap moveHeroDirection:@"down" itemPicked:itemPicked];
//    if (code == 2) {
//        /* INITATE COMBAT */
//        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
//    } else if (code == 3) {
//        // INITATE VICTORY DUNGEON
//    }
//
//    if ([itemPicked length] != 0) {
//        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
//        self.MainTextField.text = _mainText;
//        /* AUTO ROLL DOWN */
//        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
//        [self.MainTextField scrollRangeToVisible:range];
//    }
//    self.MapTextField.text = [_currMap printMap];
//}
//- (IBAction)left:(id)sender {
//    NSMutableString *itemPicked = [[NSMutableString alloc] init];
//    int code = [_currMap moveHeroDirection:@"left" itemPicked:itemPicked];
//    if (code == 2) {
//        /* INITATE COMBAT */
//        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
//    } else if (code == 3) {
//        // INITATE VICTORY DUNGEON
//    }
//
//    if ([itemPicked length] != 0) {
//        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
//        self.MainTextField.text = _mainText;
//        /* AUTO ROLL DOWN */
//        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
//        [self.MainTextField scrollRangeToVisible:range];
//    }
//    self.MapTextField.text = [_currMap printMap];
//}
//- (IBAction)right:(id)sender {
//    NSMutableString *itemPicked = [[NSMutableString alloc] init];
//    int code = [_currMap moveHeroDirection:@"right" itemPicked:itemPicked];
//    if (code == 2) {
//        /* INITATE COMBAT */
//        [self performSegueWithIdentifier:@"combatSegue" sender:sender];
//    } else if (code == 3) {
//        // INITATE VICTORY DUNGEON
//    }
//
//    if ([itemPicked length] != 0) {
//        [_mainText appendFormat:@"------------------\n%s", [itemPicked UTF8String]];
//        self.MainTextField.text = _mainText;
//        /* AUTO ROLL DOWN */
//        NSRange range = NSMakeRange(self.MainTextField.text.length - 1, 1);
//        [self.MainTextField scrollRangeToVisible:range];
//    }
//    self.MapTextField.text = [_currMap printMap];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
