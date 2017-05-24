//
//  Space.m
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Space.h"

@implementation Space
int x;
int y;
Item *item;

-(id)initx:(int)aX y:(int)aY item:(Item*)aItem {
    _x = aX;
    _y = aY;
    _item = aItem;
    return self;
}


@end