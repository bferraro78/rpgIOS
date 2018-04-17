//
//  PartyMemberView.m
//  RPG
//
//  Created by james schuler on 4/13/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartyMemberView.h"
@implementation PartyMemberView

-(void)setUpSubviews:(Hero*)aHero {
    
    _Hero = aHero;    
    
    CGFloat width = [super frame].size.width;
    
    /* Create Labels  */
    UILabel *Name = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 5.0, width-10.0, 25.0)];
    UILabel *ClassLevel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 30.0, width-10.0, 25.0)];
    
    NSString *NameString = [NSString stringWithFormat:@"%s", [_Hero.name UTF8String]];
    NSString *ClassLevelString = [NSString stringWithFormat:@"Level %i %s", _Hero.level, [[_Hero getClassName] UTF8String]];
    
    Name.text = NameString;
    ClassLevel.text =  ClassLevelString;
    
    /* Create Health and Resource Bars */
    _HealthBar = [[HealthBar alloc] initWithFrame:CGRectMake(5.0, 60.0, width-50.0, 8.0)];
    _ResourceBar = [[ResourceBar alloc] initWithFrame:CGRectMake(5.0, 71.0, width-50.0, 8.0)];
    
    _HealthBar.fullHealth = _Hero.health;
    _HealthBar .currentHealth = _Hero.combatHealth;
    
    _ResourceBar.fullResource = [_Hero getResource];
    _ResourceBar.currentResource = [_Hero getCombatResource];
    
    [super addSubview:Name];
    [super addSubview:ClassLevel];
    [super addSubview:_HealthBar];
    [super addSubview:_ResourceBar];
}


@end
