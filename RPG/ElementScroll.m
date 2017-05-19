//
//  ElementScroll.m
//  RPG
//
//  Created by Ben Ferraro on 5/18/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElementScroll.h"
#import "Hero.h"
@implementation ElementScroll

-(id)initdescription:(NSString *)aDescription {

    [super inititemDescription:aDescription];
    return self;
}

-(NSString*)getType { return @""; } // NO TYPE, FOR OTHER ITEMS

-(void)activateItem:(Hero*)mainCharacter {}
-(void)deactivateItem:(Hero*)mainCharacter {}

@end