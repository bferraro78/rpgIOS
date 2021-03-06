//
//  Poisonstone.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poisonstone.h"
@implementation Poisonstone

NSString *poisonStoneElement;
int poisonStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement {
    [super inititemDescription:aDescription];
    _poisonStoneElement = aElement;
    return self;
}

-(NSString*)getType { return @"Poisonstone"; }
-(void)generate { self.poisonStonePotency = arc4random_uniform(15)+5;}
-(NSString*)getElement { return self.poisonStoneElement; }
-(int)getPotency { return self.poisonStonePotency; }
-(NSString*)toString {
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret appendFormat:@"%s - %u%%", [[self getType] UTF8String], [self getPotency]];
    return ret;
}

@end