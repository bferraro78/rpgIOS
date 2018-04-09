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

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[_appDelegate mcManager] setupPeerAndSessionWithDisplayName:mainCharacter.name];
    
    /* Register Observers for sending messages */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ReadyCheckNotificationRecieved:)
                                                 name:@"ReadyCheckNotification"
                                               object:nil];
    
    // Add yourself to the party
    [[Party getPartyArray] addToParty:[[PartyMember alloc] initWith:mainCharacter.name]];
    [self setReadyCheckButtonTitle]; // change button status
}

/** Notification Functions **/
/* Get ready check from other users */
-(void)ReadyCheckNotificationRecieved:(NSNotification *)notification {
    NSString *readyCheck = [[notification userInfo] objectForKey:@"receivedString"];
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    
    Party *p = [Party getPartyArray];
    PartyMember *member = [p getPartyMember:peerDisplayName];
    member.readyCheck = ([readyCheck isEqualToString:READY]) ? true : false;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setReadyCheckButtonTitle];
    });
    
}

/* Get Connection from user, create a party member and add to party array */
-(void)peerDidChangeStateWithNotification:(NSNotification *)notification {
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    Party *partyArray = [Party getPartyArray];
    PartyMember *partyMember = [[PartyMember alloc] initWith:peerDisplayName];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            [partyArray addToParty:partyMember];
        } else if (state == MCSessionStateNotConnected) {
            if ([partyArray partyCount] > 0) {
                [partyArray removeFromParty:partyMember];
            }
        }
    }
    
    /* Now that we are in a party together, send if you are currenyly ready */
    PartyMember *mainCharacterInParty = [[Party getPartyArray] getPartyMember:mainCharacter.name];
    NSString *readyString = (mainCharacterInParty.readyCheck) ? READY : NOTREADY;
    [self sendReadyCheck:readyString];
}

/* Sends Ready Check to other users */
-(void)sendReadyCheck:(NSString*)readyString {
    NSData *dataToSend = [readyString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

-(void)setReadyCheckButtonTitle {
    /* Change Name of Buttons */
    int readyCount = 0;
    Party *p = [Party getPartyArray];
    for (int i = 0; i < [p partyCount]; i++) {
        PartyMember *member = (PartyMember*)[p.PartyArray objectAtIndex:i];
        if (member.readyCheck) {
            readyCount++;
        }
    }
    
    NSString *readyCheckString = [NSString stringWithFormat:@"Ready Check: %i", readyCount];
    [_ReadyCheckButton setTitle:readyCheckString forState:UIControlStateNormal];
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
    
    [self setReadyCheckButtonTitle];
    [self sendReadyCheck:readyString];
}

/* Party up button, brings up MCViewController */
- (IBAction)PartyUp:(id)sender {
    [[_appDelegate mcManager] advertiseSelf:true];
    
    /* Show search browser */
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
}

// Done Button
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

// Cancel Button
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

@end
