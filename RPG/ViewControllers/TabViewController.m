//
//  TabViewController.m
//  RPG
//
//  Created by james schuler on 4/13/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TabViewController.h"
@implementation TabViewController

-(void)viewDidLoad {
    
    self.navigationItem.hidesBackButton = YES;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainDungeonViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"MainDungeonViewController"];
    EquipViewController* vc2 = [storyboard instantiateViewControllerWithIdentifier:@"EquipViewController"];
    HeroProfileViewController* vc5 = [storyboard instantiateViewControllerWithIdentifier:@"HeroProfileViewController"];
    PartyMember *m = [[Party getPartyArray].PartyArray objectAtIndex:0];
    vc5.partyMember = m;
    
    // Sets up any data before viewDidLoad
    // 1. Sets name of the tab in TabBarUI
    [vc1 setUpTabBarView];
    [vc2 setUpTabBarView];
    [vc5 setUpTabBarView];
    
    // Table Views
    SkillViewController* vc3 = [[SkillViewController alloc] init];
    InventoryViewController* vc4 = [[InventoryViewController alloc] init];
    
    NSArray* controllers = [NSArray arrayWithObjects:vc1, vc2, vc3, vc4, vc5, nil];
    self.viewControllers = controllers;
    self.selectedViewController = vc1;
    
    UIBarButtonItem *WiewPartyButton = [[UIBarButtonItem alloc] initWithTitle:@"Party" style:UIBarButtonItemStylePlain target:self action:@selector(ViewPartyButton)];
    self.navigationItem.rightBarButtonItem = WiewPartyButton;
    
    self.view.window.rootViewController = self.navigationController;
    
}

-(void)ViewPartyButton {
    [self performSegueWithIdentifier:@"partyViewSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"partyViewSegue"]) {
        
    }
}

@end
