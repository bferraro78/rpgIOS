//
//  EnterDungeonController.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnterDungeonController.h"

@implementation EnterDungeonController 

// Remove observer for loading a hero
-(void)viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReadyCheckNotification" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LoadPartyMemberNotification" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    /* Register Observers for sending messages */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createPartyMemberNotificationRecieved:)
                                                 name:@"createPartyMemberNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReadyCheckNotification:)
                                                 name:@"readyCheckNotification"
                                               object:nil];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AllUsersStartDungeon:)
                                                 name:@"EnterDungeonNotification"
                                               object:nil];
    
    // Add yourself to the party
    [[Party getPartyArray] addToParty:[[PartyMember alloc] initWith:mainCharacter]];
    
     // change button statuses
    [self setPartyButtonTitle];
    
    /* Party table */
    _tablePartyView.delegate = self;
    _tablePartyView.dataSource = self;
    _tablePartyView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tablePartyView.layer.borderColor = [[UIColor colorWithRed:255.0/255 green:130.0/255 blue:102.0/255.0 alpha:1.0] CGColor];
    _tablePartyView.layer.borderWidth = 2.0;
    _tablePartyView.backgroundColor = [UIColor clearColor];
    _tablePartyView.userInteractionEnabled = YES;
}

/** Recieved Notification Functions **/
/* Create Party Member, load a hero and ready check from other users */
-(void)createPartyMemberNotificationRecieved:(NSNotification *)notification {
    NSDictionary *partyMemberInfo = [[notification userInfo] objectForKey:@"receivedData"];
    
    Party *p = [Party getPartyArray];
    // Load Party Hero
    // Create party member
    // Add to party
    Hero *partyMemberHero = [CreateClassManager loadPartyMember:partyMemberInfo];
    PartyMember *partyMember = [[PartyMember alloc] initWith:partyMemberHero];
    [p addToParty:partyMember];
    
    partyMember.readyCheck = ([partyMemberInfo[@"readyCheck"] isEqualToString:READY]) ? true : false;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tablePartyView reloadData];
        [self setPartyButtonTitle];
    });
}

/* Party Member already in party, just ready check has changed */
-(void)ReadyCheckNotification:(NSNotification *)notification {
    NSDictionary *readyCheck = [[notification userInfo] objectForKey:@"receivedData"];
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    Party *p = [Party getPartyArray];
    PartyMember *member = [p getPartyMember:peerDisplayName];
    member.readyCheck = ([readyCheck[@"readyCheck"] isEqualToString:READY]) ? true : false;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_tablePartyView reloadData];
    });
    
}

/* All users enter dungeon */
-(void)AllUsersStartDungeon:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"enterDungeonSegue" sender:nil];
    });
}

/* Get Connection from user send hero data and ready check */
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            
            /* 1. Now that we are in a party together, send if you are currenyly ready
               2. Send hero stat data over to the other users */
            [self sendPartyMemberInfo];
            
        } else if (state == MCSessionStateNotConnected) {
            Party *partyArray = [Party getPartyArray];
            if ([partyArray partyCount] > 0) {
                [partyArray removeFromParty:peerDisplayName];
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setPartyButtonTitle];
        [self->_tablePartyView reloadData];
    });
}

/* Send hero data over */
-(void)sendPartyMemberInfo {
    NSMutableDictionary *dictionaryToSend = [mainCharacter heroPartyMemberToDictionary];
    
    PartyMember *mainCharacterInParty = [[Party getPartyArray] getPartyMember:mainCharacter.name];
    NSString *readyString = (mainCharacterInParty.readyCheck) ? READY : NOTREADY;
    dictionaryToSend[@"readyCheck"] = readyString;
    dictionaryToSend[@"action"] = @"createPartyMember";
    
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:dictionaryToSend options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

/** Buttons **/
-(void)setPartyButtonTitle {
    /* Change Name of Buttons */
    Party *p = [Party getPartyArray];
    NSString *partyString = ([p partyCount] > 1) ? @"Leave Party" : @"Party Up";
    [_PartyUp setTitle:partyString forState:UIControlStateNormal];
}

- (IBAction)ReadyCheck:(id)sender {
    NSString *readyString;
    
    PartyMember *mainCharacterInParty = [[Party getPartyArray] getPartyMember:mainCharacter.name];
    
    if (_ReadyCheckButton.backgroundColor == [UIColor greenColor]) {
        [_ReadyCheckButton setBackgroundColor:[UIColor whiteColor]];
        readyString = NOTREADY;
        mainCharacterInParty.readyCheck = false;
    } else {
        [_ReadyCheckButton setBackgroundColor:[UIColor greenColor]];
        readyString = READY;
        mainCharacterInParty.readyCheck = true;
    }
    
    [_tablePartyView reloadData];
    [self sendReadyCheck:readyString];
}

-(void)sendReadyCheck:(NSString*)readyString {
    NSData *dataToSend = [NSJSONSerialization dataWithJSONObject:[self packageReadyCheck:readyString] options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(NSMutableDictionary*)packageReadyCheck:(NSString*)readyString {
    NSMutableDictionary *readyCheckDictionary = [[NSMutableDictionary alloc] init];
    readyCheckDictionary[@"action"] = @"readyCheck";
    readyCheckDictionary[@"readyCheck"] = readyString;
    return readyCheckDictionary;
}

-(IBAction)EnterDungeonButton:(id)sender {
    Party *party = [Party getPartyArray];
    int readyCount = [party readyCheckCount];
    int partyCount = [party partyCount];
    if (partyCount == readyCount) {
        if (partyCount > 1) {
            [self sendStartDungeon];
        }
        [self performSegueWithIdentifier:@"enterDungeonSegue" sender:nil];
    } else {
        [UIView animateWithDuration:0.1 delay:0.0 options:0 animations:^{
            [self->_EnterDungeonButton setBackgroundColor:[UIColor redColor]];
        } completion:^(BOOL finished) {
            [self->_EnterDungeonButton setBackgroundColor:[UIColor lightGrayColor]];
        }];
    }
}

-(void)sendStartDungeon {
    NSData* dataToSend = [NSJSONSerialization dataWithJSONObject:[self sendStartDungeonDictionary] options:0 error:nil];
    NSArray *allPeers = [MCManager getMCManager].session.connectedPeers;
    NSError *error;
    [[MCManager getMCManager].session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(NSMutableDictionary*)sendStartDungeonDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"action"] = @"startDungeon";
    return jsonable;
}

/* Party up button, brings up MCViewController */
- (IBAction)PartyUp:(id)sender {
    if ([_PartyUp.titleLabel.text isEqualToString:@"Leave Party"]) {
        [[MCManager getMCManager].session disconnect]; // disconnect from group
    } else {
        [[MCManager getMCManager] setupPeerAndSessionWithDisplayName:mainCharacter.name];
        
        [[MCManager getMCManager] advertiseSelf:true];
        /* Show search browser */
        [[MCManager getMCManager] setupMCBrowser];
        [[[MCManager getMCManager] browser] setDelegate:self];
        [self presentViewController:[[MCManager getMCManager] browser] animated:YES completion:nil];
    }
}

// Done Button
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [[MCManager getMCManager].browser dismissViewControllerAnimated:YES completion:nil];
}

// Cancel Button
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [[MCManager getMCManager].browser dismissViewControllerAnimated:YES completion:nil];
}

/* Table delegates */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text; // character name
    
    // Show player profile
    _partyMemberProfile = [[Party getPartyArray] getPartyMember:cellText];
    /* Go to profile */
    [self performSegueWithIdentifier:@"heroProfileSegue" sender:nil];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[Party getPartyArray] partyCount];
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    // Deciding which data to put into this particular cell.
    // If it the first row, the data input will be "Data1" from the array.
    NSUInteger row = [indexPath row];
    
    PartyMember* partyMember = [[Party getPartyArray] partyMemberAtIndex:row];
    
    if ([[Party getPartyArray] getPartyMember:partyMember.partyMemberHero.name].readyCheck) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = partyMember.partyMemberHero.name;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"heroProfileSegue"]) {
        HeroProfileViewController *profile = (HeroProfileViewController*)[segue destinationViewController];
        [profile setPartyMember:_partyMemberProfile];
    }
}

@end
