//
//  Item.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
@implementation Item
/* This class hold the structure for an Item */

NSString *itemDescription;

-(id)inititemDescription:(NSString*)aDescription {
    _itemDescription = aDescription;
    return self;
}


/* Methods*/
-(NSString*)toString { return @""; }
-(NSString*)getType { return @""; }
-(NSString*)getElement { return @""; }
-(int)getPotency { return 0; }
-(void)generate { }

@end
