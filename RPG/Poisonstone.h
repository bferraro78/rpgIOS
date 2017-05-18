//
//  Poisonstone.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Poisonstone_h
#define Poisonstone_h
#import "Item.h"
@interface Poisonstone : Item

@property NSString *poisonStoneElement;
@property int poisonStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;

@end


#endif /* Poisonstone_h */
