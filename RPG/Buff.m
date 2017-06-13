//
//  Buff.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Buff.h"
@implementation Buff
int value;
int duration;

-(id)initvalue:(int)aValue duration:(int)aDuration {
    _value = aValue;
    _duration = aDuration;
    return self;
}

-(NSString*)toString {
   return @"";
}

-(void)decreaseDuration { self.duration -= 1; }

@end