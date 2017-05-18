//
//  Lightningstone.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Lightningstone_h
#define Lightningstone_h
#import "Item.h"
@interface Lightningstone : Item

@property NSString *lightningStoneElement;
@property int lightningStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;

@end

#endif /* Lightningstone_h */
