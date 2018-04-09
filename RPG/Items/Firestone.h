//
//  Firestone.h
//  RPG
//
//  Created by Ben Ferraro on 5/16/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Firestone_h
#define Firestone_h
#import "Item.h"
@interface Firestone : Item

@property NSString *fireStoneElement;
@property int fireStonePotency;


-(id)initdescription:(NSString*)aDescription Element:(NSString*)aElement;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;
-(NSString*)toString;
-(void)generate;

@end


#endif /* Firestone_h */
