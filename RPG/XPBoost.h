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
#import "Hero.h"
@interface XPBoost : Item

@property int XPPotency;


-(id)initdescription:(NSString*)aDescription;
-(NSString*)getType;
-(int)getPotency;
-(NSString*)toString;
-(void)generate;

@end


#endif /* XPBoost_h */
