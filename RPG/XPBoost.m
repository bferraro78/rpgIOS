//
//  XPBoost.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XPBoost.h"
@implementation XPBoost


int XPPotency;


-(id)initdescription:(NSString*)aDescription {
    [super inititemDescription:aDescription];
    return self;
}

-(NSString*)getType { return @"XPBoost"; }
-(void)generate { self.XPPotency = arc4random_uniform(15)+5; }
-(int)getPotency { return self.XPPotency; }
-(NSString*)toString {
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret appendFormat:@"%s - %u%%", [[self getType] UTF8String], [self getPotency]];
    return ret;
}

@end