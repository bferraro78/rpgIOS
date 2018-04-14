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


-(void)viewDidAppear:(BOOL)animated {

}

-(void)viewDidLoad {
    _heroProfileTextView.selectable = false;
    _heroProfileTextView.text =  [_partyMember.partyMemberHero printStats];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_heroProfileTextView scrollRangeToVisible:NSMakeRange(0, 0)];
    });
    
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
