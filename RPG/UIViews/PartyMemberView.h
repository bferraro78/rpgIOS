//
//  PartyMemberView.h
//  RPG
//
//  Created by james schuler on 4/13/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyMemberView_h
#define PartyMemberView_h
#import <UIKit/UIKit.h>
#import "Hero.h"
#import "HealthBar.h"
#import "ResourceBar.h"

/** Represents a view for a party member: Name Label w/ level/class, health bar, resource bar, dot map (on hold) **/
@interface PartyMemberView : UIView

@property Hero *Hero;
@property HealthBar *HealthBar;
@property ResourceBar *ResourceBar;

-(void)setUpSubviews:(Hero*)aHero;

@end

#endif /* PartyMemberView_h */
