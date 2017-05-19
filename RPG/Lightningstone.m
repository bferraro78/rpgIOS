//
//  Lightningstone.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lightningstone.h"
@implementation Lightningstone

NSString *lightningStoneElement;
int lightningStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement {
    [super inititemDescription:aDescription];
    _lightningStoneElement = aElement;
    [self generate];
    return self;
}

-(NSString*)getType { return @"Lightningstone"; }
-(void)generate { self.lightningStonePotency = arc4random_uniform(15)+5;}
-(NSString*)getElement { return self.lightningStoneElement; }
-(int)getPotency { return self.lightningStonePotency; }

-(void)activateItem:(Hero*)mainCharacter {}
-(void)deactivateItem:(Hero*)mainCharacter {}

@end