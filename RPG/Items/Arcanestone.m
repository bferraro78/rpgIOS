//
//  Arcanestone.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Arcanestone.h"
@implementation Arcanestone

NSString *arcaneStoneElement;
int arcaneStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement {
    [super inititemDescription:aDescription];
    _arcaneStoneElement = aElement;
    return self;
}

-(NSString*)getType { return @"Arcanestone"; }
-(void)generate { self.arcaneStonePotency = arc4random_uniform(15)+5;}
-(NSString*)getElement { return self.arcaneStoneElement; }
-(int)getPotency { return self.arcaneStonePotency; }
-(NSString*)toString {
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret appendFormat:@"%s - %u%%", [[self getType] UTF8String], [self getPotency]];
    return ret;
}

@end