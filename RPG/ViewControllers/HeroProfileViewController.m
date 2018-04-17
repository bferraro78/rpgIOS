//
//  HeroProfileViewController.m
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroProfileViewController.h"

@implementation HeroProfileViewController


-(void)viewWillAppear:(BOOL)animated {
    // Sometimes this view controller is part of the nav controller, other times part of the tabBar controller
    [self.tabBarController setTitle:[NSString stringWithFormat:@"%@", _partyMember.partyMemberHero.name]];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", _partyMember.partyMemberHero.name]];
    
    NSString *buttonTitle = ([_ChangeHeroInfoButton.titleLabel.text isEqualToString:@"View Equipment"]) ? @"View Equipment" : @"View Stats";
    [_ChangeHeroInfoButton setTitle:buttonTitle forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated {
    _heroProfileTextView.selectable = false;
    _heroProfileTextView.text = ([_ChangeHeroInfoButton.titleLabel.text isEqualToString:@"View Equipment"]) ?
    [_partyMember.partyMemberHero printStats] : [_partyMember.partyMemberHero printBody];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_heroProfileTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    });
}

-(void)viewDidLoad {
    [_ChangeHeroInfoButton setTitle:@"View Equipment" forState:UIControlStateNormal];
}

-(void)setUpTabBarView {
    UITabBarItem *bitem = [[UITabBarItem alloc] init];
    bitem.title = @"Hero";
    self.tabBarItem = bitem;
}

-(void)setPartyMember:(PartyMember*)pm {
    _partyMember = pm;
}

- (IBAction)ChangeHeroInfoButton:(id)sender {
    _heroProfileTextView.text = @"";
    if ([_ChangeHeroInfoButton.titleLabel.text isEqualToString:@"View Equipment"]) {
        _heroProfileTextView.text =  [_partyMember.partyMemberHero printBody];
        [_ChangeHeroInfoButton setTitle:@"View Stats" forState:UIControlStateNormal];
    } else {
        _heroProfileTextView.text =  [_partyMember.partyMemberHero printStats];
        [_ChangeHeroInfoButton setTitle:@"View Equipment" forState:UIControlStateNormal];
    }
    
}

@end
