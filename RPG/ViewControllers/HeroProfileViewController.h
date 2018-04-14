//
//  HeroProfileViewController.h
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef HeroProfileViewController_h
#define HeroProfileViewController_h
#import <UIKit/UIKit.h>
#import "Hero.h"
#import "PartyMember.h"

@interface HeroProfileViewController : UIViewController

@property (strong, nonatomic) PartyMember *partyMember;
@property (strong, nonatomic) IBOutlet UITextView *heroProfileTextView;
@property (strong, nonatomic) IBOutlet UIButton *ChangeHeroInfoButton;

-(void)setUpTabBarView;
-(void)setPartyMember:(PartyMember*)pm;

@end

#endif /* HeroProfileViewController_h */
