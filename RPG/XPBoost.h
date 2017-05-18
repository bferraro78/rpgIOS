//
//  XPBoost.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef XPBoost_h
#define XPBoost_h
#import "Item.h"
@interface XPBoost : Item

@property int XPPotency;


-(id)initdescription:(NSString*)aDescription;
-(NSString*)getType;
-(int)getPotency;

@end


#endif /* XPBoost_h */
