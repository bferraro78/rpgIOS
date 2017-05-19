//
//  ElementScroll.h
//  RPG
//
//  Created by Ben Ferraro on 5/18/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef ElementScroll_h
#define ElementScroll_h
#import "Item.h"
@interface ElementScroll : Item

-(id)initdescription:(NSString*)aDescription;
-(NSString*)getType;
-(void)activateItem:(Hero*)mainCharacter;
-(void)deactivateItem:(Hero*)mainCharacter;

@end


#endif /* ElementScroll_h */
