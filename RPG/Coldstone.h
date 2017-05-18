
//
//  Coldstone.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Coldstone_h
#define Coldstone_h
#import "Item.h"
@interface Coldstone : Item

@property NSString *coldStoneElement;
@property int coldStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;

@end

#endif /* Coldstone_h */
