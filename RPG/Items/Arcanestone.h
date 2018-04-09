//
//  Arcanestone.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Arcanestone_h
#define Arcanestone_h
#import "Item.h"
@interface Arcanestone : Item

@property NSString *arcaneStoneElement;
@property int arcaneStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;
-(NSString*)toString;
-(void)generate;

@end

#endif /* Arcanestone_h */
