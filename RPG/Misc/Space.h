//
//  Space.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Space_h
#define Space_h
#import "Item.h"
@class Space;
@interface Space : NSObject

@property int x;
@property int y;
@property Item *item;

-(id)initx:(int)aX y:(int)aY item:(Item*)aItem;

@end

#endif /* Space_h */
