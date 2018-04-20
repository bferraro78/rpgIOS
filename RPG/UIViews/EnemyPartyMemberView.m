//
//  EnemyPartyMemberView.m
//  RPG
//
//  Created by james schuler on 4/19/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyPartyMemberView.h"
@implementation EnemyPartyMemberView

-(void)setUpSubviews:(Enemy*)aEnemy {
    
    _Enemy = aEnemy;
    
    CGFloat width = [super frame].size.width;
    
    /* Create Labels  */
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, width-10.0, 25.0)];
    
    NSString *NameString = [NSString stringWithFormat:@"%s", [_Enemy.name UTF8String]];
    
    Name.text = NameString;
    
    /* Create Health and Resource Bars */
    _HealthBar = [[HealthBar alloc] initWithFrame:CGRectMake(5.0, 30.0, width-50.0, 8.0)];
//    _ResourceBar = [[ResourceBar alloc] initWithFrame:CGRectMake(5.0, 71.0, width-50.0, 8.0)];
    
    _HealthBar.fullHealth = _Enemy.health;
    _HealthBar .currentHealth = _Enemy.combatHealth;
    
//    _ResourceBar.fullResource = [_Enemy.reso];
//    _ResourceBar.currentResource = [_Enemy getCombatResource];
    
    [super addSubview:Name];
    [super addSubview:_HealthBar];
//    [super addSubview:_ResourceBar];
}


@end


