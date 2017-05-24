//
//  Item.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Item_h
#define Item_h
@class Item;
@interface Item : NSObject

@property NSString *itemDescription;

/* Methods */
-(id)inititemDescription:(NSString*)aDescription;
-(NSString*)toString;
-(NSString*)getType;
-(NSString*)getElement;
-(int)getPotency;
-(void)generate;

@end

#endif /* Item_h */
