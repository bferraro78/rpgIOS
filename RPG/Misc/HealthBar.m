//
//  HealthBar.m
//  RPG
//
//  Created by james schuler on 4/2/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import "HealthBar.h"

@implementation HealthBar

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    return self;
}

-(void)setHealthBar:(int)currentHealth {
    _currentHealth = currentHealth;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {

    float percentRemaining = _currentHealth/_fullHealth;

    CGRect leftRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percentRemaining, rect.size.height);
    [[UIColor greenColor] set];
    UIRectFill(leftRect);
}

@end
