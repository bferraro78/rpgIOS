//
//  ResourceBar.m
//  RPG
//
//  Created by james schuler on 4/4/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResourceBar.h"

@implementation ResourceBar

-(void)setResourceBar:(int)currentResource {
    _currentResource = currentResource;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    float percentRemaining = _currentResource/_fullResource;
    CGRect leftRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width * percentRemaining, rect.size.height);
    [[UIColor blueColor] set];
    UIRectFill(leftRect);
}

@end
