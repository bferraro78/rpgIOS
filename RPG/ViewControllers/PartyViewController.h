//
//  PartyViewController.h
//  RPG
//
//  Created by james schuler on 4/12/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyViewController_h
#define PartyViewController_h
#import <UIKit/UIKit.h>
#import "HeroPartyMemberView.h"
#import "Party.h"
#import "HeroProfileViewController.h"

@interface PartyViewController : UIViewController

@property HeroPartyMember *partyMemberProfile; // temp for viewing another character


@end

#endif /* PartyViewController_h */
