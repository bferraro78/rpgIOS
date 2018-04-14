//
//  EnterDungeonController.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EnterDungeonController_h
#define EnterDungeonController_h
#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "MCManager.h"
#import "Party.h"
#import "Constants.h"
#import "CreateClassManager.h"
#import "MainCharacter.h"
#import "HeroProfileViewController.h"

@interface EnterDungeonController : UIViewController <MCBrowserViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property PartyMember *partyMemberProfile;

@property (strong, nonatomic) IBOutlet UIButton *PartyUp;
@property (strong, nonatomic) IBOutlet UIButton *ReadyCheckButton;
@property (strong, nonatomic) IBOutlet UIButton *EnterDungeonButton;
@property (strong, nonatomic) IBOutlet UITableView *tablePartyView;
@property (strong, nonatomic) IBOutlet UILabel *partyLabel;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification;

@end

#endif /* EnterDungeonController_h */
