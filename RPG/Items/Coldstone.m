//
//  Coldstone.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coldstone.h"
@implementation Coldstone

NSString *coldStoneElement;
int coldStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement {
    [super inititemDescription:aDescription];
    _coldStoneElement = aElement;
    return self;
}

-(NSString*)getType { return @"Coldstone"; }
-(void)generate { self.coldStonePotency = arc4random_uniform(15)+5;}
-(NSString*)getElement { return self.coldStoneElement; }
-(int)getPotency { return self.coldStonePotency; }
-(NSString*)toString {
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret appendFormat:@"%s - %u%%", [[self getType] UTF8String], [self getPotency]];
    return ret;
}


@end