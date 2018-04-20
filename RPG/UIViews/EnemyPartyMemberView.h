//
//  EnemyPartyMemberView.h
//  RPG
//
//  Created by james schuler on 4/19/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef EnemyPartyView_h
#define EnemyPartyView_h
#import <UIKit/UIKit.h>
#import "Enemy.h"
#import "HealthBar.h"
#import "ResourceBar.h"

/** Represents a view for a party member: Name Label w/ level/class, health bar, resource bar, dot map (on hold) **/
@interface EnemyPartyMemberView : UIView

@property Enemy *Enemy;
@property HealthBar *HealthBar;
@property ResourceBar *ResourceBar;

-(void)setUpSubviews:(Enemy*)aEnemy;

@end

#endif /* EnemyPartyMemberView_h */
