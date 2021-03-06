//
//  Firestone.m
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Firestone.h"
@implementation Firestone

NSString *fireStoneElement;
int fireStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement {
    [super inititemDescription:aDescription];
    _fireStoneElement = aElement;
    return self;
}

-(NSString*)getType { return @"Firestone"; }
-(void)generate { self.fireStonePotency = arc4random_uniform(15)+5; }
-(NSString*)getElement { return self.fireStoneElement; }
-(int)getPotency { return self.fireStonePotency; }

-(NSString*)toString {
    NSMutableString *ret = [[NSMutableString alloc] init];
    [ret appendFormat:@"%s - %u%%", [[self getType] UTF8String], [self getPotency]];
    return ret;
}



@end
