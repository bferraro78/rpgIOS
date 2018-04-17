//
//  PartyViewController.m
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartyViewController.h"
@implementation PartyViewController


-(void)viewWillAppear:(BOOL)animated {
    [self.tabBarController setTitle:@"Party"];
    [self.navigationItem setTitle:@"Party"];
}

-(void)viewDidLoad {
    
    UITabBarItem *bitem = [[UITabBarItem alloc] init];
    bitem.title = @"Party";
    self.tabBarItem = bitem;
    
    [self addViews];
}

-(void)addViews {
    
    CGFloat width = self.view.frame.size.width;
    int y = 85.0;
    
    for (int i = 0; i < [[Party getPartyArray] partyCount]; i++) {
        PartyMember *pm = [[Party getPartyArray] partyMemberAtIndex:i];
        PartyMemberView *HeroView = [[PartyMemberView alloc] initWithFrame:CGRectMake(10.0, y, width-20.0, 50.0)];
        [HeroView setUpSubviews:pm.partyMemberHero];
        
        /* Clear text field long tap */
        UITapGestureRecognizer *viewProfile = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(ViewHeroProfile:)];
        [HeroView addGestureRecognizer:viewProfile];
        
        [self.view addSubview:HeroView];
        
        y+= 90.0;
    }
}

-(void)ViewHeroProfile:(id)sender {
    PartyMemberView *pv = (PartyMemberView*) [sender view];
    // Show player profile
    _partyMemberProfile = [[Party getPartyArray] getPartyMember:pv.Hero.name];
    /* Go to profile */
    [self performSegueWithIdentifier:@"heroProfileSegue" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"heroProfileSegue"]) {
        HeroProfileViewController *profile = [segue destinationViewController];
        profile.partyMember = _partyMemberProfile;
    }
}

@end
