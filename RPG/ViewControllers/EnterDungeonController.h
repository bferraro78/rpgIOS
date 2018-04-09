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
#import "AppDelegate.h"
#import "Party.h"
#import "Constants.h"

@interface EnterDungeonController : UIViewController <MCBrowserViewControllerDelegate>

@property (nonatomic, strong) AppDelegate *appDelegate;

@property (strong, nonatomic) IBOutlet UIButton *PartyUp;
@property (strong, nonatomic) IBOutlet UIButton *ReadyCheckButton;
@property (strong, nonatomic) IBOutlet UIButton *SoloDungeon;

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification; // helper ^^
-(void)sendReadyCheck:(NSString*)readyString;

@end

#endif /* EnterDungeonController_h */
